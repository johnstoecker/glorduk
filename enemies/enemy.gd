extends RigidBody2D
class_name Enemy

@onready var _animated_sprite = $AnimatedSprite2D

@export var enemy_scene: PackedScene

var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	_animated_sprite.play("e_walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_position(pos: Vector2):
	position = pos

func start_velocity(vel: Vector2):
	linear_velocity = vel.normalized() * speed

func _on_body_entered(body):
	print("enemy hit", body)
	if body.is_in_group(Globals.GROUP_PLAYER):
		Events.emit_signal("player_damaged", 1)
	# TODO: attack, reset timer


func repath_to_player():
	var player_pos = get_tree().get_nodes_in_group("player")[0].global_position
	linear_velocity = (player_pos - position).normalized() * speed
	#print(player_pos)

func die():
	print("i died!")
	queue_free()
