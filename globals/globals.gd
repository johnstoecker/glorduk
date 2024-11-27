extends Node

enum building_types {FARM, BARRACKS, TROLL_CABIN, TOWN_HALL, TOWN_HALL_2, TOWN_HALL_3}

enum enemy_types {SKELETON, TROLL }

var GROUP_PLAYER = "player"
var GROUP_ENEMIES = "enemies"

# does not include walls (or outside trees etc
var num_tiles_across = 50
var num_tiles_down = 50

var tile_size = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
