extends Node

var enemy_scene = preload("res://enemies/enemy.tscn")
var troll_scene = preload("res://enemies/troll/troll.tscn")
var spawner_scene = preload("res://entities/spawner/spawner.tscn")
var eye_scene = preload("res://entities/projectiles/eye/eye.tscn")


var enemy_path_calc_timer = 0
var recalculate_enemy_paths_at = 0.5 # recalculate paths every x seconds

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)

	Events.connect("put_eye", _on_put_eye)
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	PlayerManager.handle_join_input()

	enemy_path_calc_timer += delta
	if enemy_path_calc_timer >= recalculate_enemy_paths_at:
		enemy_path_recalculate()
		enemy_path_calc_timer = 0


func _on_put_eye(loc: Vector2):
	var new_eye = eye_scene.instantiate()
	new_eye.position = loc
	add_sibling(new_eye)

const TILE_SIZE = 32
func tile_to_pos(tile: Vector2) -> Vector2:
	return Vector2(tile.x * TILE_SIZE, tile.y * TILE_SIZE)

func new_game() -> void:
	# $Player.start(tile_to_pos(Vector2(2, 2)))
	# $Player2.start(tile_to_pos(Vector2(3, 3)))
	add_spawner(Globals.building_types.FARM, Vector2(300, 300), false)
	add_spawner(Globals.building_types.BARRACKS, Vector2(800, 300), false)

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


func enemy_path_recalculate():
	get_tree().call_group("enemies", "repath_to_player")


func spawn_enemy(enemy_type: Globals.enemy_types, position: Vector2):
	var new_enemy
	if enemy_type == Globals.enemy_types.SKELETON:
		new_enemy = enemy_scene.instantiate()
	elif enemy_type == Globals.enemy_types.TROLL:
		new_enemy = troll_scene.instantiate()
	else:
		new_enemy = enemy_scene.instantiate()
	new_enemy.start_position(position)
	new_enemy.start_velocity(Vector2(150, 150))
	add_sibling(new_enemy)


# map from player integer to the player node
var player_nodes = {}

func spawn_player(player: int):
	# create the player node
	var player_scene = load("res://entities/player/player.tscn")
	var player_node: Player = player_scene.instantiate()
	player_node.leave.connect(on_player_leave)
	player_nodes[player] = player_node

	# let the player know which device controls it
	var device = PlayerManager.get_player_device(player)
	player_node.init(player, device)

	# add the player to the tree
	add_child(player_node)

	# random spawn position inside the "spawn area"
	var tile = Vector2(randi_range(2, 3), randi_range(2, 3))
	player_node.position = tile_to_pos(tile)

func delete_player(player: int):
	player_nodes[player].queue_free()
	player_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	PlayerManager.leave(player)
