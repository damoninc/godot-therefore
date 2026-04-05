# godot-therefore Design

Date: 2026-04-05

## Overview

`godot-therefore` is a Godot 4 desktop game repository for a JRPG-style technical demo. The first milestone is a small, playable overworld exploration slice that proves the project can support an attractive, expandible classic-JRPG direction without committing early to story, combat, or content-heavy systems.

The visual target is adjacent to Octopath Traveler, modern Pokemon, and Stardew Valley in spirit, but the technical approach favors a fast, low-risk 2D-first implementation over full 3D scene complexity. The demo should feel sharp, readable, and worth building on, not fully polished.

## Goals

- Build a desktop-first Godot 4 repo for a JRPG-style prototype.
- Prove top-down overworld exploration with strong movement, camera, and map readability.
- Establish clean extension points for later scene transitions, NPC interactions, interiors, and battle hooks.
- Use placeholder art so gameplay and architecture decisions are not blocked by asset sourcing.
- Optimize for the fastest path to a playable demo rather than long-term tool sophistication.

## Non-Goals

- Full battle system
- Inventory, quests, or party management
- Story tooling or setting definition
- Large content pipeline
- Full save/load implementation beyond a future stub point
- Heavy 3D rendering or cinematic presentation

## Chosen Stack

- Engine: `Godot 4`
- Scripting: `GDScript`
- Runtime target: desktop-first
- Rendering direction: 2D-first with selective lighting, layering, shaders, and mild depth tricks

This stack is chosen because it offers the shortest path to a playable overworld demo while still supporting a visually strong 2.5D-adjacent presentation. Godot's scene workflow, tilemap support, and low-friction scripting fit the prototype goal better than Unity or Unreal for this phase.

## Design Direction

The project should read as a classic JRPG overworld rather than a renderer showcase. The intended look is a practical midpoint:

- richer than flat retro tilemaps
- less technically demanding than full Octopath-style HD-2D
- visually adjacent to modern Pokemon or Stardew Valley in clarity and attractiveness

The demo should achieve this through:

- layered environment composition
- selective lighting
- camera polish
- modest VFX
- careful map composition

It should not depend on true 3D traversal or deep 3D environment systems.

## Demo Scope

The first playable demo is a single small overworld slice.

It should include:

- one outdoor map with readable terrain, paths, and landmarks
- a controllable player with top-down movement
- collision and movement feel that already reads as intentional
- a few interactables such as a sign, a door, and one NPC stand-in
- at least one map trigger or scene transition hook
- a minimal UI prompt for interactions
- placeholder lighting and VFX sufficient to evaluate the visual direction

It should prove:

- player movement feels good
- the camera frames the play space well
- world interactions are easy to add
- the project structure can scale into towns, interiors, dungeons, and encounter hooks

## Architecture

The initial architecture should stay small and explicit.

Recommended scene and system layout:

- `Main` scene as the project entry point
- `World` scene as the playable overworld map
- `Player` scene for movement, animation, and interaction checks
- `Interactable` base pattern for reusable interactive objects
- `MapTransition` trigger areas for later scene changes
- minimal `UI` layer for prompts and temporary debug text
- `GameState` autoload for shared flags and future progression hooks

Technical principles:

- gameplay should remain 2D-first
- map logic should not depend on specific placeholder assets
- shared state should live outside individual scenes when it will later matter across maps
- interaction hooks should be reusable enough to support doors, signs, NPCs, and simple triggers

## Tooling And Content Pipeline

The repository should start with a simple content pipeline built around placeholder assets.

Recommended repository layout:

- `project.godot`
- `scenes/`
- `scripts/`
- `assets/tiles/`
- `assets/characters/`
- `assets/props/`
- `assets/ui/`
- `autoload/`
- `docs/`

Asset policy:

- start with placeholder art only
- keep asset folders domain-oriented so future replacement is low-risk
- avoid coupling gameplay scripts directly to art filenames wherever possible
- treat placeholders as intentionally temporary and swap-ready

No heavy external art ingestion pipeline is needed for v1.

## Environment Note

Initial repo setup can happen inside the current WSL Ubuntu workspace without issue. However, ongoing day-to-day Godot editing is expected to be smoother from the Windows side later. The repository can be cloned again on Windows when active editor-driven development begins.

This does not change the repo design. It only affects where the Godot editor is likely to be used most comfortably.

## Success Criteria

The first playable demo is successful when:

- it launches quickly into a playable overworld
- movement and collision feel deliberate
- the map already suggests a JRPG world worth extending
- interaction hooks are present and clearly reusable
- the presentation demonstrates that a sharp 2D-first look is viable in Godot 4

## Repo Identity

- Repository name: `godot-therefore`
- Repository path: `/home/damon/GitHub/godot-therefore` <- For local development on WSL
- Project purpose: Godot 4 JRPG-style overworld technical demo with clean foundations for later expansion
