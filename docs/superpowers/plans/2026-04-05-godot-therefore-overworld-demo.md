# godot-therefore Overworld Demo Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the first playable Godot 4 overworld exploration demo for `godot-therefore`, including movement, interactions, a small map, and basic presentation polish.

**Architecture:** The demo is a 2D-first Godot 4 project with a small scene tree and explicit boundaries. `Main` boots the game, `World` owns the playable map, `Player` owns movement and interaction checks, `Interactable` nodes expose a common interaction surface, and a lightweight `GameState` autoload holds shared flags for future progression and transitions.

**Tech Stack:** Godot 4, GDScript, `.tscn` scenes, placeholder sprite and tile assets, git

---

## Planned File Structure

- `project.godot`
  Purpose: Godot project configuration and autoload registration.
- `icon.svg`
  Purpose: temporary project icon so Godot opens cleanly.
- `autoload/game_state.gd`
  Purpose: shared state for interaction flags and current map metadata.
- `scenes/main.tscn`
  Purpose: boot scene that loads the first playable world.
- `scripts/main.gd`
  Purpose: startup handoff from `Main` to `World`.
- `scenes/world/world.tscn`
  Purpose: main overworld map scene.
- `scripts/world/world.gd`
  Purpose: world-level references for player spawn, prompt display, and transition hooks.
- `scenes/player/player.tscn`
  Purpose: reusable player scene with sprite, collision, and interaction probe.
- `scripts/player/player.gd`
  Purpose: top-down movement, facing direction, and interaction requests.
- `scenes/interactables/sign.tscn`
  Purpose: simple sign interaction example.
- `scenes/interactables/door.tscn`
  Purpose: simple door interaction example.
- `scenes/interactables/npc_stand_in.tscn`
  Purpose: placeholder NPC interaction example.
- `scripts/interactables/interactable.gd`
  Purpose: shared base behavior for interaction targets.
- `scripts/interactables/sign.gd`
  Purpose: sign-specific message data.
- `scripts/interactables/door.gd`
  Purpose: door-specific behavior and placeholder transition metadata.
- `scripts/interactables/npc_stand_in.gd`
  Purpose: NPC stand-in message behavior.
- `scenes/ui/interact_prompt.tscn`
  Purpose: minimal prompt and debug text overlay.
- `scripts/ui/interact_prompt.gd`
  Purpose: prompt visibility and text updates.
- `assets/tiles/placeholder_tileset.png`
  Purpose: temporary environment tiles.
- `assets/characters/player_placeholder.png`
  Purpose: temporary player sprite sheet or single-frame placeholder.
- `assets/props/placeholder_props.png`
  Purpose: temporary props for landmarks and interaction nodes.
- `assets/ui/prompt_panel.png`
  Purpose: optional placeholder UI panel backing.
- `.gitignore`
  Purpose: ignore Godot import artifacts and editor metadata.

### Task 1: Bootstrap The Godot Project

**Files:**
- Create: `project.godot`
- Create: `icon.svg`
- Create: `.gitignore`

- [ ] **Step 1: Create the root project files**

```ini
; project.godot
config_version=5

[application]
config/name="godot-therefore"
run/main_scene="res://scenes/main.tscn"
config/features=PackedStringArray("4.2")
config/icon="res://icon.svg"

[autoload]
GameState="*res://autoload/game_state.gd"

[display]
window/size/viewport_width=1280
window/size/viewport_height=720
window/stretch/mode="canvas_items"
window/stretch/aspect="keep"

[rendering]
textures/canvas_textures/default_texture_filter=0
```

```svg
<!-- icon.svg -->
<svg xmlns="http://www.w3.org/2000/svg" width="128" height="128" viewBox="0 0 128 128">
  <rect width="128" height="128" rx="20" fill="#20243a"/>
  <path d="M24 92 L64 28 L104 92 Z" fill="#7ec8a5"/>
  <circle cx="64" cy="72" r="12" fill="#f2d17c"/>
</svg>
```

```gitignore
# Godot 4 imports and editor state
.godot/
*.import
export_presets.cfg
```

- [ ] **Step 2: Create the project folders**

Run: `mkdir -p autoload scenes/world scenes/player scenes/interactables scenes/ui scripts/world scripts/player scripts/interactables scripts/ui assets/tiles assets/characters assets/props assets/ui`
Expected: directory tree exists with no output

- [ ] **Step 3: Open the project in Godot and verify it loads**

Run: `godot4 --path . --editor`
Expected: Godot opens `godot-therefore` without configuration errors and shows an empty filesystem tree

- [ ] **Step 4: Commit the bootstrap**

```bash
git add .gitignore icon.svg project.godot
git commit -m "chore: bootstrap Godot project"
```

### Task 2: Add Global State And The Main Boot Scene

**Files:**
- Create: `autoload/game_state.gd`
- Create: `scenes/main.tscn`
- Create: `scripts/main.gd`
- Modify: `project.godot`

- [ ] **Step 1: Write the initial shared state script**

```gdscript
# autoload/game_state.gd
extends Node

var current_map_id: String = "world"
var player_spawn_marker: String = "start"
var flags: Dictionary = {}

func set_flag(flag_name: String, value: Variant = true) -> void:
	flags[flag_name] = value

func get_flag(flag_name: String, default_value: Variant = false) -> Variant:
	return flags.get(flag_name, default_value)
```

- [ ] **Step 2: Create the main scene script**

```gdscript
# scripts/main.gd
extends Node

@onready var world_scene: PackedScene = preload("res://scenes/world/world.tscn")

func _ready() -> void:
	var world := world_scene.instantiate()
	add_child(world)
```

- [ ] **Step 3: Create the boot scene**

```tscn
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/main.gd" id="1_main"]

[node name="Main" type="Node"]
script = ExtResource("1_main")
```

- [ ] **Step 4: Verify the project starts into the boot scene**

Run: `godot4 --path .`
Expected: the project launches and then errors only on missing `world.tscn`, confirming `Main` is configured correctly

- [ ] **Step 5: Commit the boot flow**

```bash
git add autoload/game_state.gd scenes/main.tscn scripts/main.gd project.godot
git commit -m "feat: add boot scene and global state"
```

### Task 3: Implement The Player Scene And Movement

**Files:**
- Create: `scenes/player/player.tscn`
- Create: `scripts/player/player.gd`
- Create: `assets/characters/player_placeholder.png`

- [ ] **Step 1: Add the player controller script**

```gdscript
# scripts/player/player.gd
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

func try_interact() -> void:
	if not interaction_ray.is_colliding():
		return
	var collider := interaction_ray.get_collider()
	if collider != null and collider.has_method("interact"):
		collider.interact(self)
```

- [ ] **Step 2: Define the input map in `project.godot`**

```ini
[input]
move_left={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode":65,"key_label":65,"unicode":97,"echo":false,"script":null)]
}
move_right={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":68,"physical_keycode":68,"key_label":68,"unicode":100,"echo":false,"script":null)]
}
move_up={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":87,"physical_keycode":87,"key_label":87,"unicode":119,"echo":false,"script":null)]
}
move_down={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":83,"physical_keycode":83,"key_label":83,"unicode":115,"echo":false,"script":null)]
}
interact={
"deadzone": 0.2,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":69,"physical_keycode":69,"key_label":69,"unicode":101,"echo":false,"script":null)]
}
```

- [ ] **Step 3: Create the player scene**

```tscn
[gd_scene load_steps=3 format=3]

[ext_resource type="Script" path="res://scripts/player/player.gd" id="1_player"]
[ext_resource type="Texture2D" path="res://assets/characters/player_placeholder.png" id="2_player_texture"]

[node name="Player" type="CharacterBody2D"]
script = ExtResource("1_player")

[node name="Sprite2D" type="Sprite2D" parent="."]
texture = ExtResource("2_player_texture")
position = Vector2(0, -8)

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]

[node name="InteractionRay" type="RayCast2D" parent="."]
target_position = Vector2(0, 18)
enabled = true
```

- [ ] **Step 4: Add interaction input handling**

```gdscript
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		try_interact()
```

- [ ] **Step 5: Verify player movement in isolation**

Run: `godot4 --path .`
Expected: once `world.tscn` exists, the player can move with `WASD` and `E` triggers interaction attempts without runtime errors

- [ ] **Step 6: Commit the player foundation**

```bash
git add project.godot scenes/player/player.tscn scripts/player/player.gd assets/characters/player_placeholder.png
git commit -m "feat: add player movement and interaction probe"
```

### Task 4: Build The World Scene And Prompt UI

**Files:**
- Create: `scenes/world/world.tscn`
- Create: `scripts/world/world.gd`
- Create: `scenes/ui/interact_prompt.tscn`
- Create: `scripts/ui/interact_prompt.gd`
- Create: `assets/tiles/placeholder_tileset.png`
- Create: `assets/ui/prompt_panel.png`

- [ ] **Step 1: Create the interaction prompt script**

```gdscript
# scripts/ui/interact_prompt.gd
extends CanvasLayer

@onready var label: Label = $MarginContainer/Panel/Label

func show_message(text: String) -> void:
	label.text = text
	visible = true

func clear_message() -> void:
	label.text = ""
	visible = false
```

- [ ] **Step 2: Create the prompt scene**

```tscn
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/ui/interact_prompt.gd" id="1_prompt"]

[node name="InteractPrompt" type="CanvasLayer"]
visible = false
script = ExtResource("1_prompt")

[node name="MarginContainer" type="MarginContainer" parent="."]
offset_left = 24.0
offset_top = 600.0
offset_right = 520.0
offset_bottom = 688.0

[node name="Panel" type="Panel" parent="MarginContainer"]

[node name="Label" type="Label" parent="MarginContainer/Panel"]
offset_left = 20.0
offset_top = 16.0
offset_right = 440.0
offset_bottom = 48.0
text = "Placeholder prompt"
```

- [ ] **Step 3: Create the world script**

```gdscript
# scripts/world/world.gd
extends Node2D

@onready var player: CharacterBody2D = $Player
@onready var prompt: CanvasLayer = $InteractPrompt
@onready var prompt_timer: Timer = $PromptTimer

func _ready() -> void:
	add_to_group("world")
	prompt_timer.timeout.connect(_on_prompt_timer_timeout)

func show_prompt(text: String) -> void:
	prompt.show_message(text)
	prompt_timer.start()

func clear_prompt() -> void:
	prompt.clear_message()

func _on_prompt_timer_timeout() -> void:
	prompt.clear_message()
```

- [ ] **Step 4: Create the world scene**

```tscn
[gd_scene load_steps=4 format=3]

[ext_resource type="Script" path="res://scripts/world/world.gd" id="1_world"]
[ext_resource type="PackedScene" path="res://scenes/player/player.tscn" id="2_player"]
[ext_resource type="PackedScene" path="res://scenes/ui/interact_prompt.tscn" id="3_prompt"]

[node name="World" type="Node2D"]
script = ExtResource("1_world")

[node name="Ground" type="Node2D" parent="."]

[node name="Player" parent="." instance=ExtResource("2_player")]
position = Vector2(160, 160)

[node name="Camera2D" type="Camera2D" parent="Player"]
enabled = true
position_smoothing_enabled = true
position_smoothing_speed = 6.0

[node name="PromptTimer" type="Timer" parent="."]
wait_time = 2.5
one_shot = true
autostart = false

[node name="InteractPrompt" parent="." instance=ExtResource("3_prompt")]
```

- [ ] **Step 5: Add placeholder map art**

```text
Create a 16x16 or 32x32 placeholder tileset image with at least:
- grass tile
- dirt path tile
- water or cliff edge tile
- one tree or rock prop tile

Save it as `assets/tiles/placeholder_tileset.png`.
```

- [ ] **Step 6: Verify the playable world boots**

Run: `godot4 --path .`
Expected: the project opens into `World`, shows the player, and the camera follows movement smoothly

- [ ] **Step 7: Commit the world shell**

```bash
git add scenes/world/world.tscn scripts/world/world.gd scenes/ui/interact_prompt.tscn scripts/ui/interact_prompt.gd assets/tiles/placeholder_tileset.png assets/ui/prompt_panel.png
git commit -m "feat: add world scene and prompt ui"
```

### Task 5: Add Interactables And Transition Hooks

**Files:**
- Create: `scripts/interactables/interactable.gd`
- Create: `scripts/interactables/sign.gd`
- Create: `scripts/interactables/door.gd`
- Create: `scripts/interactables/npc_stand_in.gd`
- Create: `scenes/interactables/sign.tscn`
- Create: `scenes/interactables/door.tscn`
- Create: `scenes/interactables/npc_stand_in.tscn`
- Modify: `scenes/world/world.tscn`

- [ ] **Step 1: Create the shared interactable base**

```gdscript
# scripts/interactables/interactable.gd
extends Area2D
class_name Interactable

@export_multiline var interaction_text: String = "..."

func interact(actor: Node) -> void:
	var world := get_tree().get_first_node_in_group("world")
	if world != null and world.has_method("show_prompt"):
		world.show_prompt(interaction_text)
```

- [ ] **Step 2: Create the specific interactable scripts**

```gdscript
# scripts/interactables/sign.gd
extends Interactable

func _ready() -> void:
	interaction_text = "The path ahead leads toward the old hill."
```

```gdscript
# scripts/interactables/door.gd
extends Interactable

@export var target_map_id: String = "interior_stub"
@export var target_spawn_marker: String = "doorway"

func interact(actor: Node) -> void:
	GameState.current_map_id = target_map_id
	GameState.player_spawn_marker = target_spawn_marker
	super.interact(actor)
```

```gdscript
# scripts/interactables/npc_stand_in.gd
extends Interactable

func _ready() -> void:
	interaction_text = "This place feels like the beginning of something."
```

- [ ] **Step 3: Create the interactable scenes**

```tscn
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/interactables/sign.gd" id="1_sign"]

[node name="Sign" type="Area2D"]
script = ExtResource("1_sign")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
```

```tscn
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/interactables/door.gd" id="1_door"]

[node name="Door" type="Area2D"]
script = ExtResource("1_door")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
```

```tscn
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://scripts/interactables/npc_stand_in.gd" id="1_npc"]

[node name="NpcStandIn" type="Area2D"]
script = ExtResource("1_npc")

[node name="CollisionShape2D" type="CollisionShape2D" parent="."]
```

- [ ] **Step 4: Add the interactable scene references to `world.tscn`**

```tscn
[ext_resource type="PackedScene" path="res://scenes/interactables/sign.tscn" id="4_sign"]
[ext_resource type="PackedScene" path="res://scenes/interactables/door.tscn" id="5_door"]
[ext_resource type="PackedScene" path="res://scenes/interactables/npc_stand_in.tscn" id="6_npc"]
```

- [ ] **Step 5: Place the interactables into the world**

```tscn
[node name="Sign" parent="." instance=ExtResource("4_sign")]
position = Vector2(224, 128)

[node name="Door" parent="." instance=ExtResource("5_door")]
position = Vector2(320, 96)

[node name="NpcStandIn" parent="." instance=ExtResource("6_npc")]
position = Vector2(256, 224)
```

- [ ] **Step 6: Verify interaction flow**

Run: `godot4 --path .`
Expected: `E` near each object shows a distinct prompt and the door updates `GameState.current_map_id` without errors

- [ ] **Step 7: Commit the interactable system**

```bash
git add scenes/interactables/*.tscn scripts/interactables/*.gd scenes/world/world.tscn scripts/world/world.gd
git commit -m "feat: add interactables and transition hooks"
```

### Task 6: Compose The Demo Map And Apply Presentation Polish

**Files:**
- Modify: `scenes/world/world.tscn`
- Create: `assets/props/placeholder_props.png`

- [ ] **Step 1: Add visible map composition layers**

```tscn
[node name="Terrain" type="TileMap" parent="."]

[node name="Props" type="Node2D" parent="."]

[node name="Foreground" type="Node2D" parent="."]
```

- [ ] **Step 2: Add a basic directional light or tint pass**

```tscn
[node name="WorldLight" type="PointLight2D" parent="."]
position = Vector2(256, 112)
energy = 0.8
texture_scale = 4.0
color = Color(1, 0.95, 0.82, 1)
```

- [ ] **Step 3: Tune the prompt timer for short interaction text**

```tscn
[node name="PromptTimer" type="Timer" parent="."]
wait_time = 2.5
one_shot = true
autostart = false
```

- [ ] **Step 4: Shape the map into a convincing vertical slice**

```text
Using placeholder tiles and props, build:
- a grass clearing as the start area
- a path leading to one landmark
- one water, cliff, or treeline boundary for spatial definition
- one sign beside the path
- one door-like entrance landmark
- one NPC stand-in near a point of interest

Keep traversal readable and compact enough to cross in under 20 seconds.
```

- [ ] **Step 5: Run the full smoke test**

Run: `godot4 --path .`
Expected:
- launch reaches the world within a few seconds
- player movement is responsive
- camera smoothing is noticeable but not floaty
- three interaction targets work
- prompt text clears automatically
- the map already looks like a valid JRPG starting area

- [ ] **Step 6: Commit the playable slice**

```bash
git add scenes/world/world.tscn assets/props/placeholder_props.png
git commit -m "feat: build first playable overworld slice"
```
