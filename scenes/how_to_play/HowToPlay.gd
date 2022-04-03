extends Control


func _ready():
	for button in get_tree().get_nodes_in_group("Actions"):
		button.connect("pressed", self, "on_button_pressed", [button.get_name()])


func on_button_pressed(_button):
	match _button:
		"Menu": SceneManager.request_change("Menu")
