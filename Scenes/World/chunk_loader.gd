class_name ChunkLoader extends Node2D

signal world_item_dropped(sender : Node2D, item : Item, cooldown : float)

const RENDER_DISTANCE : int = 3

var terrain_gen : FastNoiseLite = preload("uid://dyd1hw7adwaqb")
const _NEW_CHUNK_PACKED : PackedScene = preload("uid://e2gerewc8xew")

var _world_name: String
var seed_int : int

var _chunk_load_queue : Array[Vector2i] = []
var _chunk_remove_queue : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func start(world_name: String, world_seed : String) -> void:
	seed_int = world_seed.hash()
	_world_name = world_name
	terrain_gen.seed = seed_int
	load_chunk(Vector2i.ZERO)
	load_chunk(Vector2i.UP)

func load_chunk(coords : Vector2i) -> void:
	var saved_chunk := saved_chunk_data(coords)
	if saved_chunk:
		var chunk : Chunk = _NEW_CHUNK_PACKED.instantiate()
		chunk.ground.tile_map_data = saved_chunk.get_ground_tile_map_data()
		chunk.above_ground.tile_map_data = saved_chunk.get_above_ground_tile_map_data()
		for breakable in saved_chunk.get_breakables():
			chunk.breakable_group.add_child(breakable)
		# TODO: Add entities where they ought to go
	else:
		_generate_chunk(coords)

func _generate_chunk(coords : Vector2i) -> void:
	var chunk : Chunk = _NEW_CHUNK_PACKED.instantiate()
	var random := RandomNumberGenerator.new()
	random.seed = seed_int
	chunk.generate(coords, random, terrain_gen, world_item_dropped)
	add_child(chunk)

func clear() -> void:
	for child in get_children():
		child.queue_free()

func chunk_in_world(chunk_coordiate: Vector2i) -> Chunk:
	for child in get_children():
		if child is Chunk:
			if child.get_coordinate() == chunk_coordiate:
				return child
	return null

## TODO: Flesh out
func is_chunk_in_world(chunk_coordiate: Vector2i) -> bool:
	return chunk_in_world(chunk_coordiate) != null

## TODO: Flesh out
func saved_chunk_data(chunk_coordiate: Vector2i) -> ChunkSave:
	return SaveLoad.load_chunk(_world_name, chunk_coordiate)

func on_player_position_updated(pos: Vector2) -> void:
	
	
	var player_chunk_coordinate : Vector2i = floor(pos / Vector2(World.TILE_SIZE * World.CHUNK_SIZE))
	for x in range((-1 * RENDER_DISTANCE), 1 + (1 * RENDER_DISTANCE)):
		for y in range((-1 * RENDER_DISTANCE), 1 + (1 * RENDER_DISTANCE)):
			var offset_chunk_coords := Vector2i(x,y)
			if offset_chunk_coords.length() <= RENDER_DISTANCE:
				var chunk_coordinate := player_chunk_coordinate + Vector2i(x,y)
				if not is_chunk_in_world(chunk_coordinate):
					if not (chunk_coordinate in _chunk_load_queue):
						_chunk_load_queue.append(chunk_coordinate)

	# Remove old chunks
	for child in get_children():
		if child is Chunk:
			var chunk_coordinate : Vector2i = child.get_coordinate()
			if (chunk_coordinate - player_chunk_coordinate).length() > RENDER_DISTANCE:
				if not (child.get_coordinate() in _chunk_remove_queue):
					_chunk_remove_queue.append(chunk_coordinate)
	
	# Load one chunk at a time
	if not _chunk_load_queue.is_empty():
		#could be pop back to be more mem efficient but pop front keeps loaded chunks clustered
		var chunk_pos : Vector2i = _chunk_load_queue.pop_front()
		load_chunk(chunk_pos)

	# Remove one chunk at a time
	if not _chunk_remove_queue.is_empty():
		#could be pop back to be more mem efficient but pop front keeps removed chunks clustered
		var chunk_pos : Vector2i = _chunk_remove_queue.pop_front()
		var chunk := chunk_in_world(chunk_pos)
		chunk.queue_free()
