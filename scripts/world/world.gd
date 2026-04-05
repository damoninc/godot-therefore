extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var prompt: CanvasLayer = $InteractPrompt
@onready var prompt_label: Label = $InteractPrompt/MarginContainer/Panel/Label
@onready var prompt_timer: Timer = $PromptTimer

func _ready() -> void:
	add_to_group("world")
	prompt_timer.timeout.connect(_on_prompt_timer_timeout)

func show_prompt(text: String) -> void:
	prompt_label.text = text
	prompt.visible = true
	prompt_timer.start()

func clear_prompt() -> void:
	prompt_label.text = ""
	prompt.visible = false

func _on_prompt_timer_timeout() -> void:
	prompt_label.text = ""
	prompt.visible = false
