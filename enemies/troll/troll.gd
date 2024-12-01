extends Enemy

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

func attack(player: Player):
	var arrow = arrow_scene.instantiate()
	var direction = player.global_position - position
	arrow.launch(direction, 30, false)
	add_child(arrow)
