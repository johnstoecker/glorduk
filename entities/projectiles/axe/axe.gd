extends Area2D
class_name Axe

# Area2D for simple bullet, if we need fancy physics stuff we should use a different node type


@export var axe_scene: PackedScene

@onready var audio_fire: AudioStreamPlayer2D = $FireSFX;
@onready var audio_hit: AudioStreamPlayer2D = $HitSFX;

var speed = 10 # TODO

var velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_screen_exit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.translate(velocity * speed * delta)

func _on_body_entered(body):
	if body.is_in_group(Globals.GROUP_ENEMIES):
		Events.emit_signal("arrow_hit")
		# NOTE: anything in "enemies" group must now implement a die() method
		body.die()
		queue_free()

# TODO: on viewport exit
func _on_screen_exit():
	queue_free()

func launch(direction: Vector2, speed: float, strength: float):
	velocity = direction * speed
	var rotate_dir = atan2(velocity.y, velocity.x)
	rotate(rotate_dir)
