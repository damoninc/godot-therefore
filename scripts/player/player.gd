extends CharacterBody2D

@export var move_speed: float = 140.0
@export var interaction_distance: float = 18.0

var facing_direction := Vector2.DOWN

@onready var sprite: Sprite2D = $Sprite2D
@onready var interaction_ray: RayCast2D = $InteractionRay

func _physics_process(_delta: float) -> void:
	var input_vector := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if input_vector != Vector2.ZERO:
		facing_direction = input_vector.normalized()
	interaction_ray.target_position = facing_direction * interaction_distance
	velocity = input_vector * move_speed
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_interact()

func try_interact() -> void:
	if not interaction_ray.is_colliding():
		return
	var collider := interaction_ray.get_collider()
	if collider != null and collider.has_method("interact"):
		collider.interact(self)
