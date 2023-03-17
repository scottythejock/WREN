extends Area2D

func _on_body_entered(body):
	if body is Player:
		body.collect_hp()
		queue_free()
