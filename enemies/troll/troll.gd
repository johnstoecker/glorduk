extends Enemy

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_proximity = 200

func attack(node):
	# _animated_sprite.play("e_attack)
	var arrow = arrow_scene.instantiate()
	var direction = node.global_position - position
	arrow.launch(direction, 30, false, 0.5)
	add_child(arrow)
