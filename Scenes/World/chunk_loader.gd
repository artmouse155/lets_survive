class_name ChunkLoader extends Node2D

signal world_item_dropped(sender : Node2D, item : Item, cooldown : float)

const RENDER_DISTANCE : int = 3

var terrain_gen : FastNoiseLite = preload("uid://dyd1hw7adwaqb")
const _NEW_CHUNK_PACKED : PackedScene = preload("uid://e2gerewc8xew")

var seed_int : int

var _chunk_load_queue : Array[Vector2i] = []

# Called when the node enters the scene tree for the first time.
func start(world_seed : String) -> void:
	seed_int = world_seed.hash()
	terrain_gen.seed = seed_int
	load_chunk(Vector2i.ZERO)
	load_chunk(Vector2i.UP)

func load_chunk(coords : Vector2i) -> void:
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

## TODO: Flesh out
func chunk_in_world(chunk_coordiate: Vector2i) -> bool:
	for child in get_children():
		if child is Chunk:
			if child.get_coordinate() == chunk_coordiate:
				return true
	return false

## TODO: Flesh out
func chunk_has_data(chunk_coordiate: Vector2i) -> bool:
	return false

func on_player_position_updated(pos: Vector2) -> void:
	var player_chunk_coordinate : Vector2i = floor(pos / Vector2(World.TILE_SIZE * World.CHUNK_SIZE))
	for x in range((-1 * RENDER_DISTANCE), 1 + (1 * RENDER_DISTANCE)):
		for y in range((-1 * RENDER_DISTANCE), 1 + (1 * RENDER_DISTANCE)):
			var offset_chunk_coords := Vector2i(x,y)
			if offset_chunk_coords.length() <= RENDER_DISTANCE:
				var chunk_coordinate := player_chunk_coordinate + Vector2i(x,y)
				if not chunk_in_world(chunk_coordinate):
					if not (chunk_coordinate in _chunk_load_queue):
						_chunk_load_queue.append(chunk_coordinate)
	
	# Generate one chunk at a time
	if not _chunk_load_queue.is_empty():
		#could be pop back to be more mem efficient but pop front keeps loaded chunks clustered
		var chunk_pos : Vector2i = _chunk_load_queue.pop_front()
		if chunk_has_data(chunk_pos):
			#TODO: Load from file
			pass
		else:
			_generate_chunk(chunk_pos)
