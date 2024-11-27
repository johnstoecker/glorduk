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

func attack(target: Vector2):
	var arrow = arrow_scene.instantiate()
	fire_timer = 0
	arrow.launch(target, 30, false)
	add_child(arrow)
