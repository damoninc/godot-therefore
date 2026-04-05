extends Interactable

@export var target_map_id: String = "world"
@export var target_spawn_marker: String = "doorway"

func interact(_actor: Node) -> void:
	GameState.current_map_id = target_map_id
	GameState.player_spawn_marker = target_spawn_marker

	var tree := get_tree()
	if tree != null:
		tree.reload_current_scene()
