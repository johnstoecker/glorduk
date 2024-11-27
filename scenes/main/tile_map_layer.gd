extends TileMapLayer

var astar_grid = AStarGrid2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar_grid.region = Rect2i(0,0, Globals.num_tiles_across, Globals.num_tiles_down)
	astar_grid.cell_size = Vector2i(Globals.tile_size, Globals.tile_size)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar_grid.update()
	# this is supposed to speed up calculation for sparse grids
	# TODO: turn this off if pathfinding becomes slow, or map is cluttered
	astar_grid.jumping_enabled = true
	for x in Globals.num_tiles_across:
		for y in Globals.num_tiles_down:
			var data = get_cell_tile_data(Vector2i(x, y))
			if data.get_collision_polygons_count(0) > 0:
				astar_grid.set_point_solid(Vector2i(x, y), true)



func set_rect_solid(start1: Vector2, tiles_across, tiles_down):
	# accound for sprite centering
	start1.x -= Globals.tile_size*tiles_across/2
	start1.y -= Globals.tile_size*tiles_down/2
	var start_pt = local_to_map(start1)
	for x in range(start_pt.x, start_pt.x + tiles_across):
		for y in range(start_pt.y, start_pt.y + tiles_down):
			astar_grid.set_point_solid(Vector2(x,y), true)
	astar_grid.update()
	var line = ""
	for x in Globals.num_tiles_across:
		line = ""
		for y in Globals.num_tiles_down:
			if astar_grid.is_point_solid(Vector2i(y, x)):
				line += "X"
			else:
				line += "*"
		print(line)

func find_path(start_pos: Vector2, end_pos: Vector2):
	var start_cell = local_to_map(start_pos)
	print(start_cell)
	var end_cell = local_to_map(end_pos)
	print(end_cell)
	# the final bool, allow_partial_path, means we return closest path if no path is found
	var path =  astar_grid.get_point_path(start_cell, end_cell, true)
	for x in range(path.size()):
		path[x-1].x += Globals.tile_size/2
		path[x-1].y += Globals.tile_size/2
	return path


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
