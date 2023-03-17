extends CharacterBody2D

var direction = Vector2.RIGHT

@onready var ledgeCheckRight: = $LedgeCheckRight
@onready var ledgeCheckleft: = $LedgeCheckLeft

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
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
	