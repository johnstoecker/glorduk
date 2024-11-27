extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.

var arrow_scene = preload("res://entities/projectiles/arrow/arrow.tscn")

@export var speed = 200

var screen_size

signal playerHit

enum States {IDLE, RUNNING, SHOOTING, DEAD}

var state: States = States.IDLE
var fire_rate = 0.5
var fire_timer = 0

var health = 1.0

var auto_fire = false

func _ready() -> void:
	screen_size = get_viewport_rect().size
	Events.connect("player_damaged", _on_player_damaged)

func start(pos):
	position = pos
	show()
	# TODO: collisionshape2d.disabled = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fire_timer += delta
	# 1. get input from gamepad or input

	velocity = _get_movement()
	var mouse_direction = (get_global_mouse_position() - self.global_position).normalized()
	_set_animation(velocity, mouse_direction)

	if velocity.length() > 0:
		state = States.RUNNING
		velocity = velocity.normalized() * speed
		move_and_slide()
	else:
		state = States.IDLE
		#TODO: shooting

	if Input.is_action_pressed("ui_accept") || auto_fire:
		state = States.SHOOTING
		if fire_timer >= fire_rate:
			var arrow = arrow_scene.instantiate()
			fire_timer = 0
			arrow.launch(mouse_direction, 30, true)
			add_child(arrow)

	Events.player_position.emit(global_position)

func _get_movement() -> Vector2:
	var velocity = Vector2.ZERO
	# TODO: gamepad movement

	if Input.is_action_pressed("ui_right") || Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left") || Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down") || Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up") || Input.is_action_pressed("move_up"):
		velocity.y -= 1
	return velocity

func _set_animation(velocity: Vector2, mouse_direction: Vector2) -> void:
	# TODO: also for shooting

	_animated_sprite.flip_h = false
	_animated_sprite.flip_v = false

	var angle = mouse_direction.angle()
	var snapper = snapped(angle, PI / 4) / (PI / 4)
	var step = wrapi(int(snapper), 0, 8)

	# animation for currently firing
	if fire_timer <= 0.4:
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
		return


	# otherwise do walking animation
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

	if velocity.x == 0 && velocity.y == 0:
		_animated_sprite.stop()

func _on_body_entered(body):
	pass
	# TODO: collisionshape2d.set_deferrred("disabled", true)
	
func _on_player_damaged(damage: float):
	health -= damage
	Events.emit_signal("update_health", health)
	
