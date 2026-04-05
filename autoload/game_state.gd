extends Node

var current_map_id: String = "world"
var player_spawn_marker: String = "start"
var flags: Dictionary = {}

func set_flag(flag_name: String, value: Variant = true) -> void:
	flags[flag_name] = value

func get_flag(flag_name: String, default_value: Variant = false) -> Variant:
	return flags.get(flag_name, default_value)
