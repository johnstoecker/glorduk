extends Enemy

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

var fire_timer = 0
## Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_proximity = 200
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fire_timer += delta

func attack(node):
	#_animated_sprite.play("e_attack")
	#node.take_damage(0.1)
#	Events.emit_signal("player_damaged", 0.1)

	var arrow = arrow_scene.instantiate()
	fire_timer = 0
	arrow.launch(node.global_position - position, 30, false, 0.1)
	add_child(arrow)
