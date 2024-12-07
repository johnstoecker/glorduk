extends Arrow
class_name Axe

# Area2D for simple bullet, if we need fancy physics stuff we should use a different node type

@export var axe_scene: PackedScene

func set_launch_sprite(direction: Vector2, speed: float, friendly_arrow: bool, strength: float):
	if direction.x < 0:
		$AnimatedSprite2D.flip_h = true
	$AnimatedSprite2D.play("default")
