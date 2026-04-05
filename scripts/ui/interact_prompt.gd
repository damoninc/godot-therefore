class_name InteractPrompt
extends CanvasLayer

@onready var label: Label = $MarginContainer/Panel/Label

func show_message(text: String) -> void:
	label.text = text
	visible = true

func clear_message() -> void:
	label.text = ""
	visible = false
