extends CenterContainer


func _ready():
	for button in get_tree().get_nodes_in_group("Actions"):
		button.connect("pressed", self, "on_button_pressed", [button.get_name()])
	get_node("VBoxContainer/Description").text = "You Scored %s Points" % Global.water_tiles
	

func on_button_pressed(_button):
	match _button:
		"Retry": SceneManager.request_change("Game")
		"Menu": SceneManager.request_change("Menu")
		"Quit": get_tree().quit()
