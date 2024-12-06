extends RigidBody2D
class_name Base

var health = 1.0

var is_friendly = true
# this is a magic number, bad...
var base_id = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func take_damage(ratio: float):
	# bases are 100x stronger than creatures
	ratio /= 10
	health -= ratio
	Events.emit_signal("update_health", health, base_id)

func init(init_is_friendly: bool):
	is_friendly = init_is_friendly
	if is_friendly:
		$OrcsSprite2D.visible = false
	else:
		base_id = 11
