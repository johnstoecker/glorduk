extends Enemy

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

var fire_timer = 0
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_proximity = 200
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fire_timer += delta

#func repath_to_player():
	#var player_pos = get_tree().get_nodes_in_group("player")[0].global_position
	#if player_pos.distance_to(position) <= troll_proximity:
		#linear_velocity = Vector2(0, 0)
		#var target = player_pos - position
		#throw_axe(target)
	#else:
		#linear_velocity = (player_pos - position).normalized() * speed
	## TODO: A* path finding

func attack(target: Vector2):
	var arrow = arrow_scene.instantiate()
	fire_timer = 0
	arrow.launch(target, 30, false)
	add_child(arrow)
