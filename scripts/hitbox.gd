extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.jump_after_hit()
		body.player_hurt()
