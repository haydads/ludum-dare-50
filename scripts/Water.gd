extends TileMap


signal game_over


var spread_water : bool = true
var current_tile : Vector2 = Vector2(20, 5)
var current_direction : Vector2
onready var PipesMap = get_node("../Pipes")


func _ready():
	# warning-ignore:return_value_discarded
	Global.connect("water_spread", self, "move_water")
	#connect("game_over", get_node("/root/Game"), )


func _process(delta):
	if spread_water: Global.reduce_timer(delta)


func move_water():
	
	for neighbour in get_neighbours(current_tile):
		var neighbour_tile = current_tile + neighbour
		#var current_pipe = PipesMap.get_cellv(current_tile)
		var pipe = PipesMap.get_cellv(neighbour_tile)
		#print("current_tile: %s, current_pipe: %s, neighbour_tile: %s, pipe_index: %s" % [current_tile, current_pipe, neighbour_tile, pipe])
		
		#if get_cellv(neighbour_tile) != -1:
			#emit_signal("game_over")
			#print("Already filled - %s" % neighbour_tile)
			#continue		
		
		var has_water = false
		match neighbour:
			Vector2.UP: if [0, 2, 4].has(pipe): has_water = true
			Vector2.DOWN: if [1, 3, 4].has(pipe): has_water = true
			Vector2.LEFT: if [0, 1, 5].has(pipe): has_water = true
			Vector2.RIGHT: if [2, 3, 5].has(pipe): has_water = true
		
		if get_cellv(neighbour_tile) != -1:
			if has_water == false:
				spread_water = false
				emit_signal("game_over")
			continue
		
		if has_water :
			current_tile = neighbour_tile
			current_direction = neighbour
			set_cellv(current_tile, pipe)
			Global.water_tiles += 1
			return
		else:
			spread_water = false
			emit_signal("game_over")


func get_neighbours(tile) -> Array:
	var neighbours = []
	match PipesMap.get_cellv(tile):
		0: neighbours = [Vector2.DOWN, Vector2.RIGHT]
		1: neighbours = [Vector2.UP, Vector2.RIGHT]
		2: neighbours = [Vector2.DOWN, Vector2.LEFT]
		3: neighbours = [Vector2.UP, Vector2.LEFT]
		4: neighbours = [Vector2.UP, Vector2.DOWN]
		5: neighbours = [Vector2.LEFT, Vector2.RIGHT]
		6: neighbours = [Vector2.LEFT]
	return neighbours


func get_opposite(direction : Vector2) -> Vector2:	
	match direction:
		Vector2.UP: return Vector2.DOWN
		Vector2.DOWN: return Vector2.UP
		Vector2.LEFT: return Vector2.RIGHT
		Vector2.RIGHT:return Vector2.LEFT
		_: return Vector2.ZERO



