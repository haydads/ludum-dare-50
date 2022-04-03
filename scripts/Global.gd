extends Node

signal water_spread

var pipe_tiles : int = 0
var water_tiles : int = 0
var current_time : float = 0.0
var timer : float = 3.0
var percentage : float = 0.0


func reduce_timer(delta):
	current_time += delta
	percentage = current_time / timer * 100
	if current_time >= timer:
		emit_signal("water_spread")
		current_time = 0.0
	pass
