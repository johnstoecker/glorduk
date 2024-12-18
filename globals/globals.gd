extends Node
class_name Global

enum building_types {ORC_FARM, ORC_BARRACKS, ORC_TROLL_CABIN, ORC_TOWN_HALL, ORC_TOWN_HALL_2, ORC_TOWN_HALL_3,
HUMAN_FARM, HUMAN_BARRACKS, HUMAN_ELF_CABIN, HUMAN_TOWN_HALL, HUMAN_TOWN_HALL_2, HUMAN_TOWN_HALL_3}

enum enemy_types {SKELETON, TROLL, FAST_SKELETON}
enum friendly_types {FOOTMAN, MAGE }

var HUMAN_HOME = Vector2(100,100)
var ORC_HOME = Vector2(1200, 100)

enum States {IDLE, RUNNING, SHOOTING, ATTACKING, DEAD}

var GROUP_PLAYER = "player"
var GROUP_ENEMIES = "enemies"
var GROUP_FRIENDLIES = "friendlies"
var GROUP_BASES = "bases"

# does not include walls (or outside trees etc
var num_tiles_across = 150
var num_tiles_down = 150

var tile_size = 32

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
