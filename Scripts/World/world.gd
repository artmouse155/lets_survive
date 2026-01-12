class_name World extends Node2D

const CHUNK_SIZE : Vector2i = Vector2i(16,16)
const TILE_SIZE : Vector2i = Vector2i(32,32)

@export var entity_spawner : EntitySpawner
@export var chunk_loader : ChunkLoader

@export var game_ui : GameUI


func start(world_save : WorldSave, player_save : PlayerSave) -> void:
	chunk_loader.start(world_save.get_world_seed())
	entity_spawner.set_spawnpoint(world_save.get_spawnpoint())
	entity_spawner.spawn_player(player_save,true)


func clear() -> void:
	entity_spawner.clear()
	chunk_loader.clear()

func get_updated_self_save() -> PlayerSave:
	return entity_spawner.get_updated_self_save.call()

## Returns the tile directly underneath the given world position.
static func world_to_tile(pos : Vector2) -> Vector2i:
	return Vector2i(pos.floor())

## Returns the center pixel position of a tile at the given indicies.
static func tile_to_world(tile : Vector2i) -> Vector2:
	return (Vector2(0.5,0.5) + Vector2(tile)) * Vector2(TILE_SIZE)
