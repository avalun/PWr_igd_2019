extends Node

var current_camera = null
var player = null
var difficulty_factor = 0

var gametime = 0

var is_over = false

func stop_game():
	is_over = true
	current_camera.stop_game()
	
func _process(delta):
	difficulty_factor = min(gametime / 120, 1)