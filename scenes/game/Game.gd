extends Control


var place_mode : bool = false
var is_valid : bool = false
var tile_index : int
var tile_order : Array = generate_tiles()
var given_up : bool = false

onready var ExclusionMap = get_node("Maps/Exclusion")
onready var PipesMap = get_node("Maps/Pipes")
onready var PreviewMap = get_node("Maps/Preview")
onready var Grid = get_node("Maps/Grid")
onready var Water = get_node("Maps/Water")
onready var WaterProgress = get_node("Interface/TextureProgress")
onready var Animator = get_node("Animation/Control/AnimationPlayer")
onready var NextPipe = get_node("Interface/NextPipe")
onready var GiveUp = get_node("Interface/GiveUp")


func _ready():
	Water.connect("game_over", self, "game_over")
	GiveUp.connect("pressed", self, "give_up_pressed")
	
	given_up = false
	Global.pipe_tiles = 0
	Global.water_tiles = 0
	Global.timer = 3.0


func _process(_delta):
	if not place_mode:
		tile_index = tile_order.pop_front()
		if tile_order.empty(): tile_order = generate_tiles()
		NextPipe.texture = load("res://assets/textures/pipes/pipe_%s.png" % tile_order.front())
		place_mode = true
		#return
	update_tile_preview()
	WaterProgress.value = Global.percentage
	WaterProgress.get_node("Label").text = str(Global.water_tiles)
	
	if not given_up:
		match Global.pipe_tiles:
			0: Global.timer = 3.0
			6: Global.timer = 2.75
			12: Global.timer = 2.5
			18: Global.timer = 2.25
			24: Global.timer = 2.0
			36: Global.timer = 1.75
			48: Global.timer = 1.5
			72: Global.timer = 1.25
			120: Global.timer = 1.0



func _unhandled_input(event):
	if event.is_action_released("place_tile") and place_mode: place_tile()
	if event.is_action_released("toggle_grid"): Grid.visible = !Grid.visible


func update_tile_preview():
	var tile_coordinates = ExclusionMap.world_to_map(get_mouse_position())

	PreviewMap.clear()
	PreviewMap.set_cellv(tile_coordinates, tile_index)
	
	is_valid = ExclusionMap.get_cellv(tile_coordinates) == -1
	PreviewMap.modulate = Color(!is_valid, is_valid, 0, 1)


func place_tile():
	if not is_valid and place_mode: return
	var tile_coordinates = ExclusionMap.world_to_map(get_mouse_position())
	PipesMap.set_cellv(tile_coordinates, tile_index)
	ExclusionMap.set_cellv(tile_coordinates, 0)
	Global.pipe_tiles += 1
	place_mode = false


func generate_tiles() -> Array:
	randomize()
	var pipes = [0, 1, 2, 3, 4, 5]
	pipes.shuffle()
	return pipes


func get_mouse_position() -> Vector2:
	var position = get_global_mouse_position() - get_node("Maps").position
	position.x = clamp(position.x, 64, 64 + 13 * 64)
	position.y = clamp(position.y, 64, 64 + 8 * 64)
	return position


func game_over():
	Animator.play("GameOver")


func go_to_game_over():
	SceneManager.request_change("GameOver")


func give_up_pressed():
	given_up = true
	Global.timer = 0.2
