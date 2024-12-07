extends Enemy

#var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")
var axe_scene = preload("res://entities/projectiles/axe/axe.tscn")
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_proximity = 200
	attack_rate = 1

func attack(node):
	# _animated_sprite.play("e_attack)
	var axe = axe_scene.instantiate()
	var direction = node.global_position - position
	axe.launch(direction, 15, false, 0.5, self)
	add_child(axe)
