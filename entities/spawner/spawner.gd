extends Area2D

var enemy_scene = preload("res://enemies/enemy.tscn")
var main_scene = preload("res://scenes/main/main.tscn")

var building_type: Globals.building_types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func place_building(new_building_type: Globals.building_types, new_position: Vector2):
	building_type = new_building_type
	position = new_position
	if building_type == Globals.building_types.FARM:
		$Sprite2D.region_rect = Rect2(334, 600, 64, 64)
	$Sprite2D.region_enabled = true
	print($Sprite2D.region_rect)

	var spawn_timer := Timer.new()
	spawn_timer.wait_time = 1.0
	add_sibling(spawn_timer)
	spawn_timer.start()
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)


func _on_spawn_timer_timeout() -> void:
	print("spawn timer timeout")
	var new_enemy = enemy_scene.instantiate()
	new_enemy.start_position(Vector2(randf_range(50, 150), randf_range(50, 150)))
	new_enemy.start_velocity(Vector2(150, 150))
	add_sibling(new_enemy)
