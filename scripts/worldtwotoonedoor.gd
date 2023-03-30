extends Area2D

func _on_body_entered(body):
	print("Player is here")
	if body is Player:
		if body.has_key == true:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			body.has_key = false
