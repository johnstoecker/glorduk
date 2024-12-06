extends Area2D
class_name Arrow

# Area2D for simple bullet, if we need fancy physics stuff we should use a different node type

#collision layer 4
# mask 2,3,5

@export var arrow_scene: PackedScene

@onready var audio_fire: AudioStreamPlayer2D = $FireSFX;
@onready var audio_hit: AudioStreamPlayer2D = $HitSFX;

var speed = 10 # TODO: simplify speed vs velocity, here and axe.gd

var velocity: Vector2

var is_friendly = false

var arrow_strength = 0.1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered", _on_body_entered)
	$VisibleOnScreenNotifier2D.connect("screen_exited", _on_screen_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.translate(velocity * speed * delta)

func _on_body_entered(body):
	if is_friendly && body.is_in_group(Globals.GROUP_ENEMIES) && is_instance_valid(body) && body.get_state() != Globals.States.DEAD:
		# NOTE: anything in "enemies" group must now implement take_damage() and die() method
		body.take_damage(arrow_strength)
		# body.die()
		queue_free()
	elif !is_friendly && body.is_in_group(Globals.GROUP_PLAYER) && body.get_state() != Globals.States.DEAD:
		body.take_damage(arrow_strength)
		# body.die()
		queue_free()
	elif !is_friendly && body.is_in_group(Globals.GROUP_FRIENDLIES) && body.get_state() != Globals.States.DEAD:
		body.take_damage(arrow_strength)
		# body.die()
		queue_free()
	elif body.is_in_group(Globals.GROUP_BASES):
		body.take_damage(arrow_strength)
		queue_free()

# TODO: on viewport exit
func _on_screen_exit():
	queue_free()

func launch(direction: Vector2, speed: float, friendly_arrow: bool, strength: float):
	arrow_strength = strength
	velocity = direction.normalized() * speed
	var rotate_dir = atan2(velocity.y, velocity.x)
	rotate(rotate_dir)
	is_friendly = friendly_arrow
