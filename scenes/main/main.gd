extends Node

var enemy_scene = preload("res://enemies/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game() -> void:
	$Player.start(Vector2(0,0))
	var spawn_timer := Timer.new()
	spawn_timer.wait_time = 3.0
	add_child(spawn_timer)
	spawn_timer.start()
	spawn_timer.connect("timeout", _on_spawn_timer_timeout)
	
	
func _on_spawn_timer_timeout() -> void:
	print("spawn timer timeout")
	var new_enemy = enemy_scene.instantiate()
	await new_enemy.is_node_ready()
	new_enemy.start_position(Vector2(randf_range(50,150), randf_range(50,150)))
	new_enemy.start_velocity(Vector2(150,150))
	add_child(new_enemy)
