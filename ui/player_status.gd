extends Control
class_name PlayerStatus

@onready var _health: Health = $Health
@onready var _name: RichTextLabel = $Name

@export var player_id = -1

func init(player_num: int):
	player_id = player_num

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_health.player_id = player_id
	_name.text = "Player %d" % player_id

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
