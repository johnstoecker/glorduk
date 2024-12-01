extends RigidBody2D
class_name Enemy

@onready var _animated_sprite = $AnimatedSprite2D

enum States {IDLE, RUNNING, ATTACKING, DEAD}
var current_state = States.IDLE

@export var movement_speed = 100
var current_path = []
var current_path_index = 0
var enemy_path_calc_timer = 0
var recalculate_enemy_path_rate = 0.5 # recalculate paths every x seconds

var attack_timer = 0
@export var attack_proximity = 50 # pixels (50 is melee range)
@export var attack_rate = 0.5 # attack every x seconds (lower number is a faster)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == States.DEAD:
		return

	# update timers
	attack_timer += delta
	enemy_path_calc_timer += delta

	# choose target
	var player = choose_target()
	if not player:
		return

	# Decide what to do...
	if player.global_position.distance_to(position) <= attack_proximity:
		# is it time to attack?
		if attack_timer < attack_rate:
			return
		attack_timer = 0

		# attack
		current_state = States.ATTACKING
		linear_velocity = Vector2(0, 0)
		attack(player)
	else:
		# is it time to repath movement?
		if enemy_path_calc_timer < recalculate_enemy_path_rate:
			return
		enemy_path_calc_timer = 0

		# update the path
		var path = get_tree().get_first_node_in_group("paths").find_path(position, player.global_position)
		current_path = path
		current_path_index = 1

		# change movement velocity
		_animated_sprite.play("e_walk")
		current_state = States.RUNNING
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * movement_speed
		else:
			linear_velocity = (player.global_position - position).normalized() * movement_speed


func init(pos: Vector2, direction: Vector2):
	position = pos
	linear_velocity = direction.normalized() * movement_speed


func choose_target() -> Player:
	var players = get_tree().get_nodes_in_group(Globals.GROUP_PLAYER)
	if !len(players):
		return
	var player: Player = players[0]
	return player


func attack(_player: Player):
	assert(false, "Enemy.attack() is a virtual method. It must be implemented in the Enemy subclass.")


func die():
	_animated_sprite.play("die")
	# interestingly, setting disabled true doesnt work, have to do deferred
	$CollisionShape2D.set_deferred("disabled", true)
	z_index = 4
	linear_velocity = Vector2i(0, 0)
	set_process(false)
	print("enemy died!")
	current_state = States.DEAD
	await get_tree().create_timer(8).timeout
	queue_free()
