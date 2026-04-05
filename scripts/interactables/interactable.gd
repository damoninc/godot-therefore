extends Area2D
class_name Interactable

@export_multiline var interaction_text: String = "..."

func interact(actor: Node) -> void:
	var world := get_tree().get_first_node_in_group("world")
	if world != null and world.has_method("show_prompt"):
		world.show_prompt(interaction_text)
