extends Control


var place_mode : bool = false
var is_valid : bool = false
var tile_index : int
var tile_order : Array = []

onready var ExclusionMap = get_node("Maps/Exclusion")
onready var PipesMap = get_node("Maps/Pipes")
onready var PreviewMap = get_node("Maps/Preview")
onready var Grid = get_node("Maps/Grid")


func _process(_delta):
	if not place_mode:
		if tile_order.empty(): tile_order = generate_tiles()
		tile_index = tile_order.pop_front()
		place_mode = true
		return
	update_tile_preview()


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
	place_mode = false


func generate_tiles() -> Array:
	randomize()
	var pipes = [0, 1, 2, 3, 4, 5]
	var options : Array = []
	for i in 1: options.append_array(pipes)
	options.shuffle()
	return options


func get_mouse_position() -> Vector2:
	var position = get_global_mouse_position() - get_node("Maps").position
	position.x = clamp(position.x, 64, 64 + 14 * 64)
	position.y = clamp(position.y, 64, 64 + 17 * 64)
	return position
