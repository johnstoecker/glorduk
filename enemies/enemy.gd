extends RigidBody2D
class_name Enemy
# z-index 5
# collision layer 3
# mask 2 + 3
# lock rotation: true
# gravity scale = 0

@onready var _animated_sprite = $AnimatedSprite2D


@export var enemy_scene: PackedScene

#Globals.States
#enum States {IDLE, RUNNING, ATTACKING, DEAD}

var current_state = Globals.States.IDLE

var speed = 100
var health = 1.0

var is_friendly = false

var current_path = []
var current_path_index = 0

var sight_proximity = 1000
var attack_proximity = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if we are close to the first node in path (10?)
	# go to second node in path, shift first off
	# otherwise no change in velocity
	if Globals.States.RUNNING && current_path_index < current_path.size():
		var distance_to_node = position - current_path[current_path_index]
		# if we are close, pop to next node
		if abs(distance_to_node.x + distance_to_node.y) < 5:
			current_path_index += 1
			if current_path_index < current_path.size():
				linear_velocity = (current_path[current_path_index] - position).normalized() * speed

func start_position(pos: Vector2):
	position = pos

func start_velocity(vel: Vector2):
	linear_velocity = vel.normalized() * speed

func _on_body_entered(body):
	pass

func old_repath_to_player():
	if current_state == Globals.States.DEAD:
		return
	#for eye in get_tree().get_nodes_in_group("eye"):
		#eye.queue_free()
	var players = get_tree().get_nodes_in_group(Globals.GROUP_PLAYER)
	if !len(players):
		return
	var player: Player = players[0]

	var player_pos = player.global_position
	var path = get_tree().get_first_node_in_group("paths").find_path(position, player_pos)
	current_path = path
	# var font = get_tree().get_nodes_in_group("")
	# for debugging paths
	#for x in range(current_path.size()):
		#Events.emit_signal("put_eye", current_path[x])
	current_path_index = 1
	if player_pos.distance_to(position) <= attack_proximity:
		current_state = Globals.States.ATTACKING
		linear_velocity = Vector2(0, 0)
		var target = player_pos - position
		attack(target)
	else:
		_animated_sprite.play("e_walk")
		current_state = Globals.States.RUNNING
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * speed
		else:
			linear_velocity = (player_pos - position).normalized() * speed

func repath_to_player():
	if current_state == Globals.States.DEAD:
		return
	var all_targets = []
	if is_friendly:
		all_targets = get_tree().get_nodes_in_group("enemies")
	else:
		all_targets = get_tree().get_nodes_in_group("friendlies")
		for x in range(get_tree().get_nodes_in_group("player").size()):
			all_targets.push_back(get_tree().get_nodes_in_group("player")[x])
	var min_distance = 3000
	var nearest_target = null
	for i in range(all_targets.size()):
		var check_target = all_targets[i]
		var distance_to_target = position.distance_to(check_target.global_position)
		if distance_to_target < min_distance && check_target.get_state() != Globals.States.DEAD:
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

func take_damage(damage: float):
	health -= damage
	if health <= 0:
		die()

func get_state() -> Globals.States:
	return current_state

func die():
	_animated_sprite.play("die")
	# interestingly, setting disabled true doesnt work, have to do deferred
	$CollisionShape2D.set_deferred("disabled", true)
	z_index = 4
	linear_velocity = Vector2i(0, 0)
	set_process(false)
	current_state = Globals.States.DEAD
	await get_tree().create_timer(8).timeout
	queue_free()
