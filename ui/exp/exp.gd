extends Control
class_name Exp

@onready var foreground: ColorRect = $Foreground
@export var target_id = -1


var amount: float = 0:
	get:
		return amount
	set(value):
		amount = clamp(value, 0, 1)
		foreground.size = Vector2(496 * amount, 48)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	amount = 0
	Events.connect("update_exp", _on_update_exp)
	Events.connect("update_skill", _on_update_skill)
	pass

func _on_update_skill(value: int, target_id_arg: int, skill: String):
	if skill == "STR":
		$STR_CONTROL/Value.text = str(value)
	elif skill == "SPD":
		$SPD_CONTROL/Value.text = str(value)

func _on_update_exp(ratio: float, target_id_arg: int):
	if target_id == target_id_arg:
		amount = ratio

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
