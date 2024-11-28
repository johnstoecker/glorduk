extends StaticBody2D

var enemy_scene = preload("res://enemies/enemy.tscn")
var main_scene = preload("res://scenes/main/main.tscn")

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
	if is_friendly:
		var friendly_type = Globals.friendly_types.FOOTMAN
		get_parent().spawn_friendly(friendly_type, position)
	else:
		var enemy_type = Globals.enemy_types.SKELETON
		if building_type == Globals.building_types.ORC_FARM:
			enemy_type = Globals.enemy_types.SKELETON
		elif building_type == Globals.building_types.ORC_BARRACKS:
			enemy_type = Globals.enemy_types.TROLL
		get_parent().spawn_enemy(enemy_type, position)

func place_building(new_building_type: Globals.building_types, new_position: Vector2, friendly: bool):
	is_friendly = friendly
	if is_friendly:
		$Sprite2DOrcs.visible = false
	else:
		$Sprite2DHumans.visible = false
	building_type = new_building_type
	position = new_position
	if building_type == Globals.building_types.ORC_FARM:
		$Sprite2DOrcs.region_rect = Rect2(338, 600, 64, 64)
		$Sprite2DOrcs.region_enabled = true
		$CollisionShape2D.shape.set_size(Vector2(64,64))
		spawn_threshold = 3
	elif building_type == Globals.building_types.ORC_BARRACKS:
		$Sprite2DOrcs.region_rect = Rect2(108, 241, 96, 96)
		$Sprite2DOrcs.region_enabled = true
		$CollisionShape2D.shape.set_size(Vector2(96,96))
		spawn_threshold = 3
	elif building_type == Globals.building_types.HUMAN_FARM:
		$Sprite2DHumans.region_rect = Rect2(395, 0, 72, 69)
		$Sprite2DHumans.region_enabled = true
		$CollisionShape2D.shape.set_size(Vector2(72,69))
		spawn_threshold = 3
	elif building_type == Globals.building_types.HUMAN_BARRACKS:
		$Sprite2DHumans.region_rect = Rect2(305, 458, 99, 96)
		$Sprite2DHumans.region_enabled = true
		$CollisionShape2D.shape.set_size(Vector2(99,97))
		spawn_threshold = 3

	spawn_timer = 0
	enabled = true
