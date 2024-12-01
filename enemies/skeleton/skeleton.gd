extends Enemy

func attack(node):
	# melee attack hits immediately
	_animated_sprite.play("e_attack")
	node.take_damage(0.05)
