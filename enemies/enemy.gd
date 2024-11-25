extends RigidBody2D
class_name Enemy

@onready var _animated_sprite = $AnimatedSprite2D

@export var enemy_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_animated_sprite.play("e_walk")	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func start_position(pos: Vector2):
	position = pos

func start_velocity(vel: Vector2):
	linear_velocity = vel

func _on_body_entered(body):
	print(body)