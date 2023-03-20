extends Area2D

var hp = 2

func _on_body_entered(body):
	if body is Player:
		body.player_hurt()
		body.jump_after_hit()
