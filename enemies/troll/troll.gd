extends Enemy

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	attack_proximity = 200
	attack_rate = 1.0

func attack(player: Player):
	var arrow = arrow_scene.instantiate()
	var direction = player.global_position - position
	arrow.launch(direction, 30, false)
	add_child(arrow)
