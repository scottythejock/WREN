extends CharacterBody2D

class_name WalkingEnemy

var direction = Vector2.RIGHT
var hp = 2

@onready var ledgeCheckRight: = $LedgeCheckRight
@onready var ledgeCheckleft: = $LedgeCheckLeft

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if hp <= 0:
		$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
		queue_free()
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if direction == Vector2.RIGHT:
		$AnimatedSprite2D.flip_h = true
	else: 
		$AnimatedSprite2D.flip_h = false
	
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheckRight.is_colliding() or not ledgeCheckleft.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
	
	velocity = direction * 25
	move_and_slide()
	
func flash():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0.8)
	$FlashTimer.start()


func _on_hitbox_body_entered(body):
	if body is Player:
		body.jump_after_hit()
		hp -= 1
		flash()
		print("HP: " + str(hp))


func _on_flash_timer_timeout():
	$AnimatedSprite2D.material.set_shader_parameter("flash_modifier", 0)
