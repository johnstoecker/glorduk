extends Area2D

var enemy_scene = preload("res://enemies/enemy.tscn")
var main_scene = preload("res://scenes/main/main.tscn")

var building_type: Globals.building_types

var spawn_timer
# how often to spawn an enemy
var spawn_threshold = 3

var enabled = false

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
		enemy_type = Globals.enemy_types.SKELETON
	get_parent().spawn_enemy(enemy_type, position)

func place_building(new_building_type: Globals.building_types, new_position: Vector2):
	building_type = new_building_type
	position = new_position
	if building_type == Globals.building_types.FARM:
		$Sprite2D.region_rect = Rect2(334, 600, 64, 64)
		spawn_threshold = 3
		spawn_timer = 0
		enabled = true

	$Sprite2D.region_enabled = true
