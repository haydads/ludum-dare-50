extends TileMap


#var timer : float = 0.0

onready var PipesMap = get_node("../Pipes")


func _ready():
	# warning-ignore:return_value_discarded
	Global.connect("water_spread", self, "move_water")


func _process(delta):
	Global.reduce_timer(delta)


func move_water():
	for tile in get_used_cells():
		
		for neighbour in get_neighbours(tile):
			var pipe = PipesMap.get_cellv(tile + neighbour)
			
			match neighbour:
				Vector2.UP: if [0, 2, 4, 6].has(pipe): set_cellv(tile + neighbour, pipe)
				Vector2.DOWN: if [1, 3, 4, 6].has(pipe): set_cellv(tile + neighbour, pipe)
				Vector2.LEFT: if [0, 1, 5, 6].has(pipe): set_cellv(tile + neighbour, pipe)
				Vector2.RIGHT: if [2, 3, 5, 6].has(pipe): set_cellv(tile + neighbour, pipe)
	#timer = 0.0


func get_neighbours(tile) -> Array:
	var neighbours = []
	match PipesMap.get_cellv(tile):
		0: neighbours = [Vector2.DOWN, Vector2.RIGHT]
		1: neighbours = [Vector2.UP, Vector2.RIGHT]
		2: neighbours = [Vector2.DOWN, Vector2.LEFT]
		3: neighbours = [Vector2.UP, Vector2.LEFT]
		4: neighbours = [Vector2.UP, Vector2.DOWN]
		5: neighbours = [Vector2.LEFT, Vector2.RIGHT]
		6: neighbours = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
	return neighbours
