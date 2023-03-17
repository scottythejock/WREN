extends Node

const HURT = preload("res://sounds/hit.wav")
const JUMP = preload("res://sounds/jump.wav")
const COIN = preload("res://sounds/coin.wav")
const LOSE = preload("res://sounds/lose.wav")
const GEM = preload("res://sounds/gem.wav")
const FLY = preload("res://sounds/fly.wav")
const HP = preload("res://sounds/hp.wav")
const LAND = preload("res://sounds/land.wav")

@onready var audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
			
func stop_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.stop()
			break

