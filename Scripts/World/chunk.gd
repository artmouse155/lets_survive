@tool
class_name Chunk extends Node2D

const _NEW_CHUNK_PACKED : PackedScene = preload("uid://e2gerewc8xew")
const _PACKED_TREE : PackedScene = preload("uid://dg8ianfbwidj5")

enum STAGE {EMPTY, FINISHED}

@export var _coordinates : Vector2i = Vector2i.ZERO:
	get:
		return _coordinates
	set(value):
		_coordinates = value
		position = _coordinates * World.TILE_SIZE * World.CHUNK_SIZE

var ground_block_grid : BlockGrid = BlockGrid.new():
	get:
		return ground_block_grid
	set(value):
		ground_block_grid = value
		_update_ground_tm()
		
var above_ground_block_grid : BlockGrid = BlockGrid.new():
	get:
		return above_ground_block_grid
	set(value):
		above_ground_block_grid = value
		_update_above_ground_tm()

@export_group("🔒 Node References")
@export var ground : TileMapLayer
@export var above_ground : TileMapLayer
@export var breakable_group : CanvasGroup


func get_coordinate() -> Vector2i:
	return _coordinates

func _generate(coordinates : Vector2i, random : RandomNumberGenerator, terrain_gen : FastNoiseLite, world_item_dropped : Signal) -> void:
	_coordinates = coordinates
	var temp_ground_block_grid := BlockGrid.new()
	var offset := _coordinates * World.CHUNK_SIZE
	for x in range(World.CHUNK_SIZE.x):
		for y in range(World.CHUNK_SIZE.y):
			var noise_val : float = terrain_gen.get_noise_2d(x + offset.x,y + offset.y)
			var block := _noise_to_block(noise_val)
			temp_ground_block_grid.set_block(Vector2i(x,y), block)
			if (random.randf() < .1) && (noise_val < .1):
				_spawn_tree(ground.map_to_local(Vector2i(x,y)), world_item_dropped)
	ground_block_grid = temp_ground_block_grid

static func generate(coordinates : Vector2i, random : RandomNumberGenerator, terrain_gen : FastNoiseLite, world_item_dropped : Signal) -> Chunk:
	var chunk : Chunk = _NEW_CHUNK_PACKED.instantiate()
	chunk._generate(coordinates, random, terrain_gen, world_item_dropped)
	return chunk

static func _noise_to_block(noise_val : float) -> StringName:
	if (noise_val < .2):
		return &"grass"
	elif (noise_val < .25):
		return &"sand"
	return &"water"

func _spawn_tree(coords : Vector2, world_item_dropped : Signal) -> void:
	var tree : Breakable = _PACKED_TREE.instantiate()
	tree.position = coords
	SignalPipe.pipe(tree.world_item_dropped,world_item_dropped)
	breakable_group.add_child(tree)

func _update_ground_tm() -> void:
	for x in range(World.CHUNK_SIZE.x):
		for y in range(World.CHUNK_SIZE.y):
			var block := ground_block_grid.get_block(Vector2i(x,y))
			var ground_block_data : BlockData = BlockData.block_data(block)
			#print("Got my atlas: %v and source id: %d" % [ground_block_data.atlas, ground_block_data.source_id])
			if ground_block_data:
				ground.set_cell(
					Vector2i(x,y), 
					ground_block_data.source_id, 
					ground_block_data.atlas)

func _update_above_ground_tm() -> void:
	# TODO: Implement above ground tilemap
	pass
	#for x in range(World.CHUNK_SIZE.x):
		#for y in range(World.CHUNK_SIZE.y):
			#var ground_block_data := BlockData.block_data(
				#ground_block_grid.get_block(Vector2i(x,y)))
			#ground.set_cell(
				#Vector2i(x,y), 
				#ground_block_data.source_id, 
				#ground_block_data.atlas)

func get_chunk_save(entity_spawner : EntitySpawner) -> ChunkSave:
	var breakables : Array[Breakable] = []
	for child in breakable_group.get_children():
		if child is Breakable:
			breakables.push_back(child)
	var chunk_save := ChunkSave.new()
	chunk_save.coordinates = _coordinates
	chunk_save.ground_block_grid = ground_block_grid
	chunk_save.above_ground_block_grid = above_ground_block_grid
	chunk_save.breakables = [] # TODO: add breakables
	chunk_save.entities = [] # TODO: add entities
	return chunk_save

static func from_chunk_save(saved_chunk: ChunkSave) -> Chunk:
	var chunk : Chunk = _NEW_CHUNK_PACKED.instantiate()
	chunk._coordinates = saved_chunk.coordinates
	chunk.ground_block_grid = saved_chunk.ground_block_grid
	chunk.above_ground_block_grid = saved_chunk.above_ground_block_grid
	for breakable in saved_chunk.breakables:
		chunk.breakable_group.add_child(breakable)
	# TODO: Add entities where they ought to go
	return chunk
