extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.player_hurt()
		if not body.is_on_floor():
			body.jump_after_hit()
