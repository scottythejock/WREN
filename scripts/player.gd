extends CharacterBody2D
class_name Player

enum { MOVE, CLIMB, FLY }

var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var hp = 3
var coins = 0
var gems = 0
var p_scale = 0

@export var moveData:Resource = preload("res://resources/defaultplayermovementdata.tres") as PlayerMovementData
@onready var animatedSprite = $AnimatedSprite2D
@onready var ladderCheck = $LadderCheck
@onready var jumpBufferTimer = $JumpBufferTimer
@onready var coyoteJumpTimer = $CoyoteJumpTimer
@onready var flashTimer = $FlashTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):	
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left","ui_right")
	input.y = Input.get_axis("ui_up","ui_down")
	
	if p_scale <= 4:
		if Input.is_action_just_pressed("ui_end"):
			p_scale += 1
			animatedSprite.scale += Vector2(1,1)
			$CollisionShape2D.scale += Vector2(1,1)
	if p_scale >= 1:
		if Input.is_action_just_pressed("ui_page_down"):
			p_scale -= 1
			animatedSprite.scale -= Vector2(1,1)
			$CollisionShape2D.scale -= Vector2(1,1)
	
	match state:
		MOVE:  move_state(input)
		CLIMB: climb_state(input)
		FLY: fly_state(input)

func _ready():
	World.Player = self
	for node in World.hpUI.get_children():
		if node is Label:
			node.set_text(str(hp))
	
func flash():
	animatedSprite.material.set_shader_parameter("flash_modifier", 0.8)
	flashTimer.start()
	
func _on_flash_timer_timeout():
	animatedSprite.material.set_shader_parameter("flash_modifier", 0)

func player_hurt():
	flash()
	SoundPlayer.play_sound(SoundPlayer.HURT)
	hp -= 1
	for node in World.hpUI.get_children():
		if node is Label:
			node.set_text(str(hp))
	if hp <= 0:
		player_die()

func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	if Input.is_action_just_pressed("ui_home"):
		state = FLY
	
	apply_gravity()

	if not horizontal_move(input):
		apply_friction()
		animatedSprite.animation = "idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "run"
		animatedSprite.flip_h = input.x > 0

	if is_on_floor():
		reset_double_jump()
	else:
		animatedSprite.animation = "jump"

	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		fast_fall()
		
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()

	move_and_slide()

	var just_landed = is_on_floor and was_in_air
	if just_landed:
		animatedSprite.animation = "run"
		animatedSprite.frame = 1
		
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input):
	if not is_on_ladder():
		state = MOVE
	animatedSprite.animation = "run"
	velocity = input * moveData.CLIMB_SPEED
	move_and_slide()

func fly_state(input):
	#SoundPlayer.play_sound(SoundPlayer.FLY)
	if Input.is_action_just_pressed("ui_home"):
		state = MOVE
	animatedSprite.flip_h = input.x > 0
	animatedSprite.animation = "fly"
	velocity = input * moveData.FLY_SPEED 
	move_and_slide()

func collect_coins():
	SoundPlayer.play_sound(SoundPlayer.COIN)
	coins += 1
	for node in World.coinUI.get_children():
		if node is Label:
			node.set_text(str(coins))
	
func collect_gems():
	SoundPlayer.play_sound(SoundPlayer.GEM)
	gems += 1
	for node in World.gemsUI.get_children():
		if node is Label:
			node.set_text(str(gems))
			
func collect_hp():
	flash()
	SoundPlayer.play_sound(SoundPlayer.HP)
	hp += 1
	for node in World.hpUI.get_children():
		if node is Label:
			node.set_text(str(hp))

			
func player_die():
	SoundPlayer.play_sound(SoundPlayer.LOSE)
	get_tree().reload_current_scene()

func input_jump_release():
	if Input.is_action_just_released("ui_accept") and velocity.y < moveData.JUMP_RELEASE_FORCE:
		velocity.y = moveData.JUMP_RELEASE_FORCE
	
func input_double_jump():
	if Input.is_action_just_pressed("ui_accept") and double_jump > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1
	
func buffer_jump():
	if Input.is_action_just_pressed("ui_accept"):
			buffered_jump = true
			jumpBufferTimer.start()

func fast_fall():
	if velocity.y > 0:
		velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
			
func can_jump():
	return is_on_floor() or coyote_jump

func horizontal_move(input):
	return input.x != 0

func reset_double_jump():
	#Reset doule jump
	double_jump = moveData.DOUBLE_JUMP_COUNT 
	
func input_jump():
	if Input.is_action_just_pressed("ui_accept") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		buffered_jump = false

func is_on_ladder():
	# checking if we are colliding with ladder
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func apply_gravity():
	velocity.y += moveData.GRAVITY
	velocity.y = min(velocity.y, 308)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION)

func _on_jump_buffer_timer_timeout():
	buffered_jump = false

func _on_coyote_jump_timer_timeout():
	coyote_jump = false
