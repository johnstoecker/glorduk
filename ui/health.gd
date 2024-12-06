extends Control
class_name Health

@onready var foreground: ColorRect = $Foreground
@export var target_id = -1

var amount: float = 1:
	get:
		return amount
	set(value):
		amount = clamp(value, 0, 1)
		foreground.size = Vector2(496 * amount, 48)
		if amount < .3:
			foreground.color = Color.RED
		elif amount < .7:
			foreground.color = Color.YELLOW
		else:
			foreground.color = Color.GREEN

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Events.connect("update_health", _on_update_health)
	pass

func _on_update_health(ratio: float, target_id_arg: int):
	print("got on update health")
	print(ratio)
	print(target_id_arg)
	print("....")
	if target_id == target_id_arg:
		amount = ratio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
