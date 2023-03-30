extends Node2D

var Player 
var coinUI
var hpUI
var gemsUI
var keyUI

func _ready():
	RenderingServer.set_default_clear_color(Color.LIGHT_CYAN)
