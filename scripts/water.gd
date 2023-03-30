extends Area2D

class_name Water

func _on_body_entered(body):
	if body is Player:
		body.moveData.Resource = load("res://resources/waterplayermovement.tres")
		print("I'm in water")
