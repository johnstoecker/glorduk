extends RigidBody2D
class_name Enemy
# z-index 5
# collision layer 3
# mask 2 + 3
# lock rotation: true
# gravity scale = 0

@onready var _animated_sprite = $AnimatedSprite2D


@export var enemy_scene: PackedScene

enum States {IDLE, RUNNING, ATTACKING, DEAD}

var current_state = States.IDLE

var speed = 100

var current_path = []
var current_path_index = 0

var attack_timer = 0
var attack_proximity = 50 # pixels (50 is melee range)
var attack_rate = 0.5 # seconds-per-attack (lower number is a faster)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")

var enemy_path_calc_timer = 0
var recalculate_enemy_paths_at = 0.5 # recalculate paths every x seconds

func choose_target() -> Player:
	var players = get_tree().get_nodes_in_group(Globals.GROUP_PLAYER)
	if !len(players):
		return
	var player: Player = players[0]
	return player

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == States.DEAD:
		return

	# choose target
	var player = choose_target()
	if not player:
		return

	attack_timer += delta

	if player.global_position.distance_to(position) <= attack_proximity:
		# attack

		if attack_timer >= attack_rate:
			attack_timer = 0
			current_state = States.ATTACKING
			linear_velocity = Vector2(0, 0)
			attack(player)

		enemy_path_calc_timer = 0 # this ensures we'll repath the next time the enemy moves
	else:
		# is it time to act (repath, attack, etc)?
		enemy_path_calc_timer += delta
		if enemy_path_calc_timer < recalculate_enemy_paths_at:
			return
		enemy_path_calc_timer = 0

		# update the path
		var path = get_tree().get_first_node_in_group("paths").find_path(position, player.global_position)
		current_path = path
		current_path_index = 1

		# move
		_animated_sprite.play("e_walk")
		current_state = States.RUNNING
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * speed
		else:
			linear_velocity = (player.global_position - position).normalized() * speed

func init(pos: Vector2, direction: Vector2):
	position = pos
	linear_velocity = direction.normalized() * speed

func _on_body_entered(body):
	pass

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
