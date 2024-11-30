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

var attack_proximity = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# if we are close to the first node in path (10?)
	# go to second node in path, shift first off
	# otherwise no change in velocity
	if States.RUNNING && current_path_index < current_path.size():
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

func repath_to_player():
	if current_state == States.DEAD:
		return
	#for eye in get_tree().get_nodes_in_group("eye"):
		#eye.queue_free()
	var players = get_tree().get_nodes_in_group(Globals.GROUP_PLAYER)
	if !len(players):
		return

	var player_pos = players[0].global_position
	var path = get_tree().get_first_node_in_group("paths").find_path(position, player_pos)
	current_path = path
	# var font = get_tree().get_nodes_in_group("")
	# for debugging paths
	#for x in range(current_path.size()):
		#Events.emit_signal("put_eye", current_path[x])
	current_path_index = 1
	if player_pos.distance_to(position) <= attack_proximity:
		current_state = States.ATTACKING
		linear_velocity = Vector2(0, 0)
		var target = player_pos - position
		attack(target)
	else:
		_animated_sprite.play("e_walk")
		current_state = States.RUNNING
		if current_path.size() > 2:
			linear_velocity = (current_path[current_path_index] - position).normalized() * speed
		else:
			linear_velocity = (player_pos - position).normalized() * speed

func attack(target: Vector2):
	_animated_sprite.play("e_attack")
	Events.emit_signal("player_damaged", 0.1)

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
