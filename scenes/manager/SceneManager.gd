extends Node


var previous : String
var current : String
var target : String


func _ready():
	request_change("Menu")


func request_change(scene : String):
	match scene:
		"Menu": target = "res://scenes/menu/Menu.tscn"
		"Game": target = "res://scenes/game/Game.tscn"
		"GameOver": target = "res://scenes/game_over/GameOver.tscn"
		"HowToPlay": target = "res://scenes/how_to_play/HowToPlay.tscn"
		"Previous": target = previous
		_: target = ""
	
	if target.empty(): return
	get_node("Canvas/Transition/Animaton").play("Fade")


func change_scene():
# warning-ignore:return_value_discarded
	get_tree().change_scene(target)
	
	previous = current
	current = target
	target = ""
