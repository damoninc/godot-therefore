extends Interactable

@export var target_map_id: String = "interior_stub"
@export var target_spawn_marker: String = "doorway"

func interact(actor: Node) -> void:
	super.interact(actor)
