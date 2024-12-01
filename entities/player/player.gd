extends CharacterBody2D
class_name Player

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _label: Label = $Label

# Called when the node enters the scene tree for the first time.

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

@export var speed = 200

var screen_size

var current_state: Globals.States = Globals.States.IDLE

# which direction the player_id is facing
var direction: Vector2 = Vector2.UP

var health = 1.0
var fire_rate = 0.5
var fire_timer = 0

## Properties for PlayerManager -- joining and leaving the game
var player_id: int
var input

# call this function when spawning this player_id to set up the input object based on the device
func init(player_num: int, device: int):
	player_id = player_num
	input = DeviceInput.new(device)

func _ready() -> void:
	screen_size = get_viewport_rect().size

	# TODO: Update HUD
	_label.text = "%s" % player_id

# func start(pos):
# 	position = pos
# 	show()

func get_direction():
	if input.is_joypad():
		return input.get_vector("face_left", "face_right", "face_up", "face_down")
	else:
		return (get_global_mouse_position() - self.global_position).normalized()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if current_state == Globals.States.DEAD:
		return

	# TODO: Consider using built-in Godot timer
	fire_timer += delta

	# let the player_id leave by pressing the "join" button
	if input.is_action_just_pressed("join"):
		PlayerManager.leave(player_id)


	# update `velocity` based on user input
	var move_input = input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	if move_input.x == 0 && move_input.y == 0:
		velocity = move_input
	else:
		velocity = move_input.normalized() * speed

	# update `direction` based on user input
	var direction_input = get_direction()
	if direction_input != Vector2.ZERO:
		# if it's ZERO, just maintain your previous direction
		direction = direction_input

	set_animation()

	if velocity.length() > 0:
		current_state = Globals.States.RUNNING
		move_and_slide()
	else:
		current_state = Globals.States.IDLE
	if input.is_action_pressed("attack"):
		current_state = Globals.States.SHOOTING
		if fire_timer >= fire_rate:
			var arrow = arrow_scene.instantiate()
			fire_timer = 0
			arrow.launch(direction, 30, true, 0.5)
			add_child(arrow)

	# TODO: handle targetting >1 player_id
	Events.player_position.emit(global_position)

func set_animation() -> void:
	_animated_sprite.flip_h = false
	_animated_sprite.flip_v = false

	var angle = direction.angle()
	var snapper = snapped(angle, PI / 4) / (PI / 4)
	var step = wrapi(int(snapper), 0, 8)

	if current_state == Globals.States.SHOOTING:
		if step == 0:
			_animated_sprite.play("e_shoot")
		elif step == 1:
			_animated_sprite.play("se_shoot")
		elif step == 2:
			_animated_sprite.play("s_shoot")
		elif step == 3:
			_animated_sprite.play("se_shoot")
			_animated_sprite.flip_h = true
		elif step == 4:
			_animated_sprite.play("e_shoot")
			_animated_sprite.flip_h = true
		elif step == 5:
			_animated_sprite.play("ne_shoot")
			_animated_sprite.flip_h = true
		elif step == 6:
			_animated_sprite.play("n_shoot")
		elif step == 7:
			_animated_sprite.play("ne_shoot")
	elif current_state == Globals.States.RUNNING:
		if step == 0:
			_animated_sprite.play("e_walk")
		elif step == 1:
			_animated_sprite.play("se_walk")
		elif step == 2:
			_animated_sprite.play("s_walk")
		elif step == 3:
			_animated_sprite.play("se_walk")
			_animated_sprite.flip_h = true
		elif step == 4:
			_animated_sprite.play("e_walk")
			_animated_sprite.flip_h = true
		elif step == 5:
			_animated_sprite.play("ne_walk")
			_animated_sprite.flip_h = true
		elif step == 6:
			_animated_sprite.play("n_walk")
		elif step == 7:
			_animated_sprite.play("ne_walk")
	elif current_state == Globals.States.IDLE:
		_animated_sprite.stop()
	elif current_state == Globals.States.DEAD:
		# TODO
		_animated_sprite.stop()

func _on_body_entered(body):
	pass
	# TODO: collisionshape2d.set_deferrred("disabled", true)
	
func get_state() -> Globals.States:
	return current_state
	
func take_damage(damage: float):
	if current_state == Globals.States.DEAD || health <= 0:
		return
	health -= damage
	Events.emit_signal("update_health", health, player_id)
	if health <= 0:
		current_state = Globals.States.DEAD
		await get_tree().create_timer(3).timeout
		current_state = Globals.States.IDLE
		position = Vector2(randi_range(96, 128), randi_range(96, 128))
		health = 1
		Events.emit_signal("update_health", health, player_id)

	# why? eh,,, to update the UI
#	Events.emit_signal("player_damaged", 0.1)
