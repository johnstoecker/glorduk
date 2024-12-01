extends Enemy

func attack(player: Player):
	# melee attack hits immediately
	_animated_sprite.play("e_attack")
	player.take_damage(0.05)
