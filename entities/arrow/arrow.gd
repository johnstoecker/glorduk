extends Area2D
# Area2D for simple bullet, if we need fancy physics stuff we should use a different node type


@export var arrow_scene: PackedScene

var speed = 10

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_screen_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.translate(velocity * speed * delta)

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		# NOTE: anything in "enemies" group must now implement a die() method
		body.die()
		queue_free()

# TODO: on viewport exit
func _on_screen_exit():
	queue_free()

func launch(direction: Vector2, speed: float):
	velocity = direction * speed
	var rotate_dir = atan2(velocity.y, velocity.x)
	print(rotate_dir)
	rotate(rotate_dir)
	
