extends Area2D
# Area2D for simple bullet, if we need fancy physics stuff we should use a different node type


@export var arrow_scene: PackedScene

var speed = 10

signal hit_something

var velocity:Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.translate(velocity * speed * delta)

func _on_body_entered(body):
	print(body)
	#if area.is_in_group("enemies"):
		#area.explode()
		#queue_free()

func launch(direction: Vector2, speed: float):
	velocity = direction * speed
	var rotate_dir = atan2(velocity.y, velocity.x)
	print(rotate_dir)
	rotate(rotate_dir)
