extends Node

signal water_spread

var current_time : float = 0.0
var timer : float = 3.0


func reduce_timer(delta):
	current_time -= delta
	if current_time <= 0.0:
		emit_signal("water_spread")
		current_time = timer
	pass
