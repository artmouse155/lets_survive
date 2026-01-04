class_name World extends Node2D

const CHUNK_SIZE : Vector2i = Vector2i(16,16)
const TILE_SIZE : Vector2i = Vector2i(16,16)

@export var entity_spawner : EntitySpawner
@export var chunk_loader : ChunkLoader

@export var game_ui : GameUI


func start(world_seed : String, player_save : PlayerSave) -> void:
	chunk_loader.start(world_seed)
	entity_spawner.spawn_player(player_save,true)


func clear() -> void:
	entity_spawner.clear()
	chunk_loader.clear()
