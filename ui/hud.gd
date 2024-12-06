extends CanvasLayer
class_name HUD

@export var player_status: PackedScene

@onready var players: Control = $Players

var active_players = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Humans.init(10)
	$Orcs.init(11)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_player(player: int) -> void:
	var n: PlayerStatus = player_status.instantiate()
	n.init(player)
	players.add_child(n)

	active_players[player] = n

	update_ui_layout()

func remove_player(player: int) -> void:
	var n: PlayerStatus = active_players[player]
	players.remove_child(n)
	active_players.erase(player)

	update_ui_layout()


func update_ui_layout():
	var padding = 24
	var player_status_height = 106
	var idx = 0
	var keys = active_players.keys()
	keys.sort()
	for k in keys:
		var n = active_players[k]
		n.position.y = padding + (idx * player_status_height)
		idx += 1
