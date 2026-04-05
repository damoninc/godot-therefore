extends Interactable

@export var target_map_id: String = "interior_stub"
@export var target_spawn_marker: String = "doorway"

func interact(actor: Node) -> void:
	GameState.current_map_id = target_map_id
	GameState.player_spawn_marker = target_spawn_marker
	super.interact(actor)
