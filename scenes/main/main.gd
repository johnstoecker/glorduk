extends Node

var healer_scene = preload("res://entities/healer/healer.tscn")
var skeleton_scene = preload("res://enemies/skeleton/skeleton.tscn")
var fast_skeleton_scene = preload("res://enemies/skeleton/fast_skeleton.tscn")
var troll_scene = preload("res://enemies/troll/troll.tscn")
var spawner_scene = preload("res://entities/spawner/spawner.tscn")
var eye_scene = preload("res://entities/projectiles/eye/eye.tscn")
var player_scene = preload("res://entities/player/player.tscn")
var footman_scene = preload("res://friendlies/footman/footman.tscn")
var base_scene = preload("res://entities/base/base.tscn")

@onready var camera: Camera2D = $PlayerManager/Camera2D
@onready var hud: HUD = $HUD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)

	Events.connect("put_eye", _on_put_eye)
	new_game()


# Move the camera to the centroid of the players' positions
func camera_follow():
	var players = get_tree().get_nodes_in_group(Globals.GROUP_PLAYER)
	var camera_pos = tile_to_pos(Vector2(3, 3))
	if len(players):
		var total = Vector2.ZERO
		for p in players:
			total += p.global_position
		total /= len(players)
		camera_pos = total
	camera.position = camera_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	PlayerManager.handle_join_input()

	camera_follow()


func _on_put_eye(loc: Vector2):
	var new_eye = eye_scene.instantiate()
	new_eye.position = loc
	add_sibling(new_eye)

const TILE_SIZE = 32
func tile_to_pos(tile: Vector2) -> Vector2:
	return Vector2(tile.x * TILE_SIZE, tile.y * TILE_SIZE)

func new_game() -> void:
#	$Player.start(Vector2(80, 80))
	add_spawner(Globals.building_types.ORC_FARM, Vector2(1200,300), false)
	add_spawner(Globals.building_types.ORC_BARRACKS, Vector2(1800,300), false)
	add_spawner(Globals.building_types.ORC_BARRACKS, Vector2(1800,500), false)
	#add_spawner(Globals.building_types.HUMAN_FARM, Vector2(1200,300), true)
	add_spawner(Globals.building_types.HUMAN_BARRACKS, Vector2(300,300), true)
	add_spawner(Globals.building_types.HUMAN_BARRACKS, Vector2(300,500), true)
	add_spawner(Globals.building_types.HUMAN_BARRACKS, Vector2(300,700), true)
	var new_healer = healer_scene.instantiate()
	new_healer.position = Vector2(96,480)
	add_child(new_healer)
	create_bases()

func create_bases():
	var orc_base = base_scene.instantiate()
	orc_base.init(false)
	orc_base.position = Globals.ORC_HOME
	add_child(orc_base)
	$TileMapLayer.set_rect_solid(Globals.ORC_HOME, 4, 4)
	
	var human_base = base_scene.instantiate()
	human_base.init(true)
	human_base.position = Globals.HUMAN_HOME
	add_child(human_base)
	$TileMapLayer.set_rect_solid(Globals.HUMAN_HOME, 4, 4)

func add_spawner(building_type: Globals.building_types, position: Vector2, is_friendly: bool):
	var new_building = spawner_scene.instantiate()
	new_building.init(building_type, position, is_friendly)
	add_child(new_building)
	var tiles_across = 4
	var tiles_down = 4
	if building_type == Globals.building_types.ORC_FARM:
		tiles_across = 3
		tiles_down = 3
	$TileMapLayer.set_rect_solid(position, tiles_across, tiles_down)

func enemy_path_recalculate():
	get_tree().call_group("enemies", "repath_to_player")
	get_tree().call_group("friendlies", "repath_to_player")


func spawn_friendly(friendly_type: Globals.friendly_types, position: Vector2):
	var new_friendly
	match friendly_type:
		Globals.friendly_types.FOOTMAN:
			new_friendly = footman_scene.instantiate()
		_:
			assert(false, "spawn_friendly got invalid friendly_type = %s" % friendly_type)
	
	new_friendly.init(position, Vector2(1,0))
	add_sibling(new_friendly)

func spawn_enemy(enemy_type: Globals.enemy_types, position: Vector2):
	var new_enemy: Enemy
	match enemy_type:
		Globals.enemy_types.SKELETON:
			new_enemy = skeleton_scene.instantiate()
		Globals.enemy_types.FAST_SKELETON:
			new_enemy = fast_skeleton_scene.instantiate()
		Globals.enemy_types.TROLL:
			new_enemy = troll_scene.instantiate()
		_:
			assert(false, "spawn_enemy got invalid enemy_type = %s" % enemy_type)

	new_enemy.init(position, Vector2(-1, 0))
	add_sibling(new_enemy)


# map from player integer to the player node
# NOTE: need Godot 4.4 before can use dictionary types.. https://github.com/godotengine/godot/pull/78656/files
# var player_nodes: Dictionary[int, Player] = {}
var player_nodes = {}

func spawn_player(player: int):
	# create the player node
	var player_node: Player = player_scene.instantiate()
	player_nodes[player] = player_node

	# let the player know which device controls it
	var device = PlayerManager.get_player_device(player)
	player_node.init(player, device)

	# add the player to the tree
	add_child(player_node)

	# random spawn position inside the "spawn area"
	var tile = Vector2(randi_range(3, 4), randi_range(11, 12))
	player_node.position = tile_to_pos(tile)

	# update the HUD
	hud.add_player(player)

func delete_player(player: int):
	player_nodes[player].queue_free()
	player_nodes.erase(player)
	hud.remove_player(player)
