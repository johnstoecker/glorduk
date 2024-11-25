extends Node

var enemy_scene = preload("res://enemies/enemy.tscn")
var spawner_scene = preload("res://entities/spawner/spawner.tscn")

var enemy_path_calc_timer = 0
var recalculate_enemy_paths_at = 0.5 # recalculate paths every x seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	enemy_path_calc_timer += delta
	if enemy_path_calc_timer >= recalculate_enemy_paths_at:
		enemy_path_recalculate()
		enemy_path_calc_timer = 0

func new_game() -> void:
	$Player.start(Vector2(80, 80))
	var start_farm = spawner_scene.instantiate()
	start_farm.place_building(Globals.building_types.FARM, Vector2(300,300))
	add_child(start_farm)

func enemy_path_recalculate():
	get_tree().call_group("enemies", "repath_to_player")


func spawn_enemy(enemy_type: Globals.enemy_types, position: Vector2):
	var new_enemy = enemy_scene.instantiate()
	new_enemy.start_position(position)
	new_enemy.start_velocity(Vector2(150, 150))
	add_sibling(new_enemy)
