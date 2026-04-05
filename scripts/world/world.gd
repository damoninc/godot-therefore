extends Node2D

const WORLD_MAP_ID := "world"
const TILE_SIZE := Vector2i(16, 16)
const TERRAIN_TEXTURE: Texture2D = preload("res://assets/tiles/placeholder_tileset.png")
const GRASS_VARIANTS := [Vector2i(0, 0), Vector2i(1, 0), Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 2), Vector2i(3, 2), Vector2i(2, 3), Vector2i(3, 3)]
const PATH_VARIANTS := [Vector2i(2, 0), Vector2i(3, 0), Vector2i(2, 1), Vector2i(3, 1)]
const WATER_VARIANTS := [Vector2i(0, 2), Vector2i(1, 2)]
const CLIFF_VARIANTS := [Vector2i(0, 3), Vector2i(1, 3)]

@onready var player: CharacterBody2D = $Player
@onready var terrain: TileMap = $Terrain
@onready var prompt: CanvasLayer = $InteractPrompt
@onready var prompt_controller: InteractPrompt = $InteractPrompt
@onready var prompt_timer: Timer = $PromptTimer
@onready var spawn_markers: Node = $SpawnMarkers

func _ready() -> void:
	add_to_group("world")
	prompt_timer.timeout.connect(_on_prompt_timer_timeout)
	_build_terrain()
	_place_player_at_spawn()
	GameState.current_map_id = WORLD_MAP_ID

func show_prompt(text: String) -> void:
	prompt_controller.show_message(text)
	prompt_timer.start()

func clear_prompt() -> void:
	prompt_controller.clear_message()

func _on_prompt_timer_timeout() -> void:
	prompt_controller.clear_message()

func _place_player_at_spawn() -> void:
	var spawn_marker_name := GameState.player_spawn_marker
	var spawn_marker := spawn_markers.get_node_or_null(spawn_marker_name) as Marker2D
	if spawn_marker == null:
		spawn_marker = spawn_markers.get_node_or_null("start") as Marker2D
		GameState.player_spawn_marker = "start"
	if spawn_marker != null:
		player.global_position = spawn_marker.global_position

func _build_terrain() -> void:
	var tile_set := TileSet.new()
	tile_set.tile_size = TILE_SIZE

	var atlas := TileSetAtlasSource.new()
	atlas.texture = TERRAIN_TEXTURE
	atlas.texture_region_size = TILE_SIZE

	for atlas_y in range(4):
		for atlas_x in range(4):
			atlas.create_tile(Vector2i(atlas_x, atlas_y))

	var source_id := tile_set.add_source(atlas)
	terrain.tile_set = tile_set

	_fill_rect(source_id, Vector2i(0, 0), Vector2i(21, 15), GRASS_VARIANTS)
	_draw_path(source_id)
	_draw_boundaries(source_id)

func _fill_rect(source_id: int, origin: Vector2i, size: Vector2i, variants: Array) -> void:
	for y in range(origin.y, origin.y + size.y):
		for x in range(origin.x, origin.x + size.x):
			var variant := variants[abs((x * 17) + (y * 31)) % variants.size()]
			terrain.set_cell(0, Vector2i(x, y), source_id, variant, 0)

func _draw_path(source_id: int) -> void:
	var path_cells := [
		Vector2i(3, 11),
		Vector2i(4, 10), Vector2i(5, 10),
		Vector2i(6, 9), Vector2i(7, 9),
		Vector2i(8, 8), Vector2i(9, 8),
		Vector2i(10, 7), Vector2i(11, 7), Vector2i(12, 7),
		Vector2i(13, 8), Vector2i(14, 8),
		Vector2i(15, 7), Vector2i(16, 7), Vector2i(17, 6), Vector2i(18, 6), Vector2i(19, 6),
	]

	for index in range(path_cells.size()):
		var variant := PATH_VARIANTS[index % PATH_VARIANTS.size()]
		terrain.set_cell(0, path_cells[index], source_id, variant, 0)

	terrain.set_cell(0, Vector2i(14, 7), source_id, Vector2i(3, 0), 0)
	terrain.set_cell(0, Vector2i(15, 8), source_id, Vector2i(2, 0), 0)
	terrain.set_cell(0, Vector2i(12, 8), source_id, Vector2i(3, 1), 0)

func _draw_boundaries(source_id: int) -> void:
	var water_cells := [
		Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0), Vector2i(3, 0), Vector2i(4, 0),
		Vector2i(0, 1), Vector2i(1, 1), Vector2i(2, 1), Vector2i(3, 1),
		Vector2i(0, 2), Vector2i(1, 2), Vector2i(2, 2),
	]

	for index in range(water_cells.size()):
		terrain.set_cell(0, water_cells[index], source_id, WATER_VARIANTS[index % WATER_VARIANTS.size()], 0)

	var cliff_cells := [
		Vector2i(17, 0), Vector2i(18, 0), Vector2i(19, 0), Vector2i(20, 0), Vector2i(21, 0),
		Vector2i(18, 1), Vector2i(19, 1), Vector2i(20, 1),
		Vector2i(19, 2), Vector2i(20, 2),
		Vector2i(20, 3), Vector2i(21, 3),
	]

	for index in range(cliff_cells.size()):
		terrain.set_cell(0, cliff_cells[index], source_id, CLIFF_VARIANTS[index % CLIFF_VARIANTS.size()], 0)
