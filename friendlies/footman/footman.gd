extends Enemy
class_name Friendly
# z-index 5
# collision layer 3
# mask 2 + 3
# lock rotation: true
# gravity scale = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_friendly = true
	attack_proximity = 50
	_animated_sprite.play("e_walk")

# TODO: delete me
func old_repath_to_player():
	if current_state == Globals.States.DEAD:
		return
	var all_targets = []
	if is_friendly:
		all_targets = get_tree().get_nodes_in_group("enemies")
	else:
		all_targets = get_tree().get_nodes_in_group("friendlies")
		all_targets.push_back(get_tree().get_nodes_in_group("player")[0])
	var min_distance = 3000
	var nearest_target = null
	for i in range(all_targets.size()):
		var check_target = all_targets[i]
		var distance_to_target = position.distance_to(check_target.global_position)
		if distance_to_target < min_distance:
			min_distance = distance_to_target
			nearest_target = check_target

	current_path_index = 1
	if min_distance <= attack_proximity:
		current_state = Globals.States.ATTACKING
		linear_velocity = Vector2(0, 0)
		attack(nearest_target)
	elif min_distance <= sight_proximity:
		var path = get_tree().get_first_node_in_group("paths").find_path(position, nearest_target.global_position)
		current_path = path
		_animated_sprite.play("e_walk")
		current_state = Globals.States.RUNNING
		# if we have a path to nearest enemy, take it
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * speed
		else:
			#otherwise send to enemy home
			if is_friendly:
				linear_velocity = (Globals.ORC_HOME - position).normalized() * speed
			else:
				linear_velocity = (Globals.HUMAN_HOME - position).normalized() * speed
	else:
		# otherwise send to enemy home
		_animated_sprite.play("e_walk")
		current_state = Globals.States.RUNNING
		if is_friendly:
			linear_velocity = (Globals.ORC_HOME - position).normalized() * speed
		else:
			linear_velocity = (Globals.HUMAN_HOME - position).normalized() * speed

func attack(node):
	_animated_sprite.play("e_attack")
	node.take_damage(0.1)
#	Events.emit_signal("player_damaged", 0.1)

func die():
	_animated_sprite.play("die")
	# interestingly, setting disabled true doesnt work, have to do deferred
	$CollisionShape2D.set_deferred("disabled", true)
	z_index = 4
	linear_velocity = Vector2i(0,0)
	set_process(false)
	print("i died!")
	current_state = Globals.States.DEAD
	await get_tree().create_timer(8).timeout
	queue_free()
	
