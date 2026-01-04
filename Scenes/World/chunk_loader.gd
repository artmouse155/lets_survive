class_name ChunkLoader extends Node2D

signal world_item_dropped(sender : Node2D, item : Item, cooldown : float)

var terrain_gen : FastNoiseLite = preload("uid://dyd1hw7adwaqb")
const _NEW_CHUNK_PACKED : PackedScene = preload("uid://e2gerewc8xew")

var seed_int : int

# Called when the node enters the scene tree for the first time.
func start(world_seed : String) -> void:
	seed_int = world_seed.hash()
	terrain_gen.seed = seed_int
	load_chunk(Vector2i.ZERO)

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
