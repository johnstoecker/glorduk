extends Node

var skeleton_scene = preload("res://enemies/skeleton/skeleton.tscn")
var fast_skeleton_scene = preload("res://enemies/skeleton/fast_skeleton.tscn")
var troll_scene = preload("res://enemies/troll/troll.tscn")
var spawner_scene = preload("res://entities/spawner/spawner.tscn")
var eye_scene = preload("res://entities/projectiles/eye/eye.tscn")
var player_scene = preload("res://entities/player/player.tscn")


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
	add_spawner(Globals.building_types.FARM, tile_to_pos(Vector2(9, 9)), false)
	add_spawner(Globals.building_types.BARRACKS, tile_to_pos(Vector2(25, 9)), false)

func add_spawner(building_type: Globals.building_types, position: Vector2, is_friendly: bool):
	var new_building = spawner_scene.instantiate()
	new_building.place_building(building_type, position, is_friendly)
	add_child(new_building)
	var tiles_across = 4
	var tiles_down = 4
	if building_type == Globals.building_types.FARM:
		tiles_across = 3
		tiles_down = 3
	$TileMapLayer.set_rect_solid(position, tiles_across, tiles_down)


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

	new_enemy.init(position, Vector2(1, 1))
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
	var tile = Vector2(randi_range(2, 3), randi_range(2, 3))
	player_node.position = tile_to_pos(tile)

	# update the HUD
	hud.add_player(player)


func delete_player(player: int):
	player_nodes[player].queue_free()
	player_nodes.erase(player)
	hud.remove_player(player)
