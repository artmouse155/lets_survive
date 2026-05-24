class_name World extends Node2D

const GAME_MUSIC : AudioStream = preload("uid://be781y8ixix8a")

const CHUNK_SIZE : Vector2i = Vector2i(16,16)
const TILE_SIZE : Vector2i = Vector2i(32,32)

@export var entity_spawner : EntitySpawner
@export var chunk_loader : ChunkLoader
@export var self_brain : SelfBrain
@export var game_ui : GameUI


func _ready() -> void:
	if self_brain:
		if entity_spawner:
			entity_spawner.self_brain = self_brain
		else:
			push_warning("No EntitySpawner connected to World node.")
	else:
		push_warning("No SelfBrain connected to World node.")
	if game_ui:
		if entity_spawner:
			entity_spawner.self_health_updated.connect(game_ui._on_health_updated)
			entity_spawner.self_inventory_updated.connect(game_ui._on_player_inventory_updated)
			entity_spawner.self_item_collected.connect(game_ui._on_item_collected)
			entity_spawner.self_selected_index_updated.connect(game_ui._on_selected_index_updated)
		else:
			push_warning("No EntitySpawner connected to World node.")
	else:
		push_warning("No Game UI connected to World node.")

func start(world_save : WorldSave, player_save : PlayerSave) -> void:
	AudioBus.play_song(GAME_MUSIC)
	chunk_loader.start(world_save.get_world_seed())
	var player_memory : PlayerMemory
	if (world_save.is_player_known(player_save)):
		player_memory = world_save.get_player_memory(player_save)
	else:
		player_memory = world_save.add_player(player_save)
		player_save.save()
		world_save.save()
	entity_spawner.spawn_player(player_save,player_memory,true)


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
