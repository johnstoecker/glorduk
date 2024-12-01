extends StaticBody2D

var building_type: Globals.building_types

var spawn_timer
# how often to spawn an enemy
var spawn_threshold = 3

var enabled = false
var is_friendly = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	spawn_timer += delta
	if enabled && spawn_timer >= spawn_threshold:
		spawn_enemy()
		#Signals.emit_signal('spawn_enemy', Globals.enemy_types.SKELETON)
		spawn_timer = 0


func spawn_enemy():
	var enemy_type = Globals.enemy_types.SKELETON
	if building_type == Globals.building_types.FARM:
		if randf() < 0.1:
			enemy_type = Globals.enemy_types.FAST_SKELETON
		else:
			enemy_type = Globals.enemy_types.SKELETON
	elif building_type == Globals.building_types.BARRACKS:
		enemy_type = Globals.enemy_types.TROLL
	get_parent().spawn_enemy(enemy_type, position)

func place_building(new_building_type: Globals.building_types, new_position: Vector2, friendly: bool):
	is_friendly = friendly
	building_type = new_building_type
	position = new_position
	if building_type == Globals.building_types.FARM:
		$Sprite2D.region_rect = Rect2(338, 600, 64, 64)
		$CollisionShape2D.shape.set_size(Vector2(64, 64))
		spawn_threshold = 3
	if building_type == Globals.building_types.BARRACKS:
		$Sprite2D.region_rect = Rect2(108, 241, 96, 96)
		$CollisionShape2D.shape.set_size(Vector2(96, 96))
		spawn_threshold = 3

	spawn_timer = 0
	enabled = true
	$Sprite2D.region_enabled = true
