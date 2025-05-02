extends TileMap

@export var map_width: int = 20
@export var map_height: int = 20
@export var available_tiles: Array = [0, 1, 2, 3, 4, 5] 

func _ready():
	randomize()
	generate_random_map()

func generate_random_map():
	for x in map_width:
		for y in map_height:
			var random_tile = available_tiles.pick_random()
			set_cell(0, Vector2i(x, y), random_tile)
