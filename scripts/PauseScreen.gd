extends CanvasLayer

func _ready():
	set_visible(false)
	
func _input(event):	
	if event.is_action_pressed("start"):
		set_visible(!get_tree().paused)
		get_tree().paused = !get_tree().paused

func _on_quit_pressed():
	get_tree().quit()

func _on_resume_pressed():
	SoundPlayer.play_sound(SoundPlayer.COIN)
	set_visible(!get_tree().paused)
	get_tree().paused = !get_tree().paused
