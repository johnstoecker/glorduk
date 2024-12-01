extends RigidBody2D
class_name Enemy

@onready var _animated_sprite = $AnimatedSprite2D

@export var enemy_scene: PackedScene

#Globals.States
#enum States {IDLE, RUNNING, ATTACKING, DEAD}

var current_state = Globals.States.IDLE

var speed = 100
var health = 1.0

var is_friendly = false

@export var movement_speed = 100

var current_path = []
var current_path_index = 0
var enemy_path_calc_timer = 0
var recalculate_enemy_path_rate = 0.5 # recalculate paths every x seconds

var attack_timer = 0
@export var attack_proximity = 50 # pixels (50 is melee range)
@export var attack_rate = 0.5 # attack every x seconds (lower number is a faster)


@export var sight_proximity = 1000
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _process(delta: float) -> void:
	if current_state == Global.States.DEAD:
		return

	# update timers
	attack_timer += delta
	enemy_path_calc_timer += delta

	# find nearest target
	var target = choose_target()

	# if no target, send them to enemy base
	if target == null:
		if is_friendly:
			linear_velocity = (Globals.ORC_HOME - position).normalized() * speed
		else:
			linear_velocity = (Globals.HUMAN_HOME - position).normalized() * speed
		return

	# Decide what to do...
	if target.global_position.distance_to(position) <= attack_proximity:
		# is it time to attack?
		if attack_timer < attack_rate:
			return
		attack_timer = 0

		# attack
		current_state = Global.States.ATTACKING
		linear_velocity = Vector2(0, 0)
		attack(target)
	else:
		# is it time to repath movement?
		if enemy_path_calc_timer < recalculate_enemy_path_rate:
			return
		enemy_path_calc_timer = 0

		# update the path
		var path = get_tree().get_first_node_in_group("paths").find_path(position, target.global_position)
		current_path = path
		current_path_index = 1

		# change movement velocity
		_animated_sprite.play("e_walk")
		current_state = Global.States.RUNNING
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * movement_speed
		else:
			linear_velocity = (target.global_position - position).normalized() * movement_speed


func init(pos: Vector2, direction: Vector2):
	position = pos
	linear_velocity = direction.normalized() * movement_speed


func choose_target():
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

	return nearest_target

func attack(node):
	#assert(false, "Enemy.attack() is a virtual method. It must be implemented in the Enemy subclass.")
	_animated_sprite.play("e_attack")
	node.take_damage(0.1)

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
