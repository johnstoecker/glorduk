extends Enemy


# # Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	super(delta)


func attack(player: Player):
	# melee attack hits immediately
	_animated_sprite.play("e_attack")
	player.take_damage(0.15)
