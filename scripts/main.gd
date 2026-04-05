extends Node

@onready var world_scene: PackedScene = preload("res://scenes/world/world.tscn")

func _ready() -> void:
	var world := world_scene.instantiate()
	add_child(world)
