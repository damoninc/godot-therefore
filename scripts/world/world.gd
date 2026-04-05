extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var prompt: CanvasLayer = $InteractPrompt
@onready var prompt_controller: InteractPrompt = $InteractPrompt
@onready var prompt_timer: Timer = $PromptTimer

func _ready() -> void:
	add_to_group("world")
	prompt_timer.timeout.connect(_on_prompt_timer_timeout)

func show_prompt(text: String) -> void:
	prompt_controller.show_message(text)
	prompt_timer.start()

func clear_prompt() -> void:
	prompt_controller.clear_message()

func _on_prompt_timer_timeout() -> void:
	prompt_controller.clear_message()
