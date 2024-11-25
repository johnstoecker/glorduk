extends Node

var enemy_scene = preload("res://enemies/enemy.tscn")
var spawner_scene = preload("res://entities/spawner/spawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game() -> void:
	$Player.start(Vector2(64, 64))
	var start_farm = spawner_scene.instantiate()
	start_farm.place_building(Globals.building_types.FARM, Vector2(0,0))
	add_child(start_farm)


func spawn_enemy(enemy_type: Globals.enemy_types, position: Vector2):
	var new_enemy = enemy_scene.instantiate()
	new_enemy.start_position(position)
	new_enemy.start_velocity(Vector2(150, 150))
	add_sibling(new_enemy)
