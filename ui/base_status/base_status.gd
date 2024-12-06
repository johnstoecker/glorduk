extends Control
class_name BaseStatus

@onready var _health: Health = $Health
@onready var _name: RichTextLabel = $Name

@export var base_id = -1

func init(base_num: int):
	base_id = base_num
	_health.target_id = base_id
	if base_id == 10:
		_name.text = "Humans"
		$HumansIcon.visible = true
		$OrcsIcon.visible = false
	elif base_id == 11:
		_name.text = "Orcs"
		$HumansIcon.visible = false
		$OrcsIcon.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
