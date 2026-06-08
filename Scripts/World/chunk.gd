@tool
class_name Chunk extends Node2D

const PACKED_TREE : PackedScene = preload("uid://dg8ianfbwidj5")

const SOURCE_ID := 1
const GRASS_ATLAS := Vector2i(0,0)
const SAND_ATLAS := Vector2i(1,0)
const WATER_ATLAS := Vector2i(2,0)

enum STAGE {EMPTY, FINISHED}

@export var _coordinates : Vector2i = Vector2i.ZERO:
	get:
		return _coordinates
	set(value):
		_coordinates = value
		position = _coordinates * World.TILE_SIZE * World.CHUNK_SIZE

@export_group("🔒 Node References")
@export var ground : TileMapLayer
@export var above_ground : TileMapLayer
@export var breakable_group : CanvasGroup

func get_coordinate() -> Vector2i:
	return _coordinates

func generate(coordinates : Vector2i, random : RandomNumberGenerator, terrain_gen : FastNoiseLite, world_item_dropped : Signal) -> void:
	_coordinates = coordinates
	var offset := _coordinates * World.CHUNK_SIZE
	for x in range(World.CHUNK_SIZE.x):
		for y in range(World.CHUNK_SIZE.y):
			var noise_val : float = terrain_gen.get_noise_2d(x + offset.x,y + offset.y)
			var tile_atlas := _noise_to_atlas(noise_val)
			ground.set_cell(Vector2i(x,y), SOURCE_ID, tile_atlas)
			if (random.randf() < .1) && (noise_val < .1):
				_spawn_tree(ground.map_to_local(Vector2i(x,y)), world_item_dropped)

static func _noise_to_atlas(noise_val : float) -> Vector2i:
	if (noise_val < .2):
		return GRASS_ATLAS
	elif (noise_val < .25):
		return SAND_ATLAS
	return WATER_ATLAS

func _spawn_tree(coords : Vector2, world_item_dropped : Signal) -> void:
	var tree : Breakable = PACKED_TREE.instantiate()
	tree.position = coords
	SignalPipe.pipe(tree.world_item_dropped,world_item_dropped)
	breakable_group.add_child(tree)

func save(entity_spawner : EntitySpawner) -> ChunkSave:
	var breakables : Array[Breakable] = []
	for child in breakable_group.get_children():
		if child is Breakable:
			breakables.push_back(child)
	return ChunkSave.new(
		_coordinates,
		ground.tile_map_data,
		above_ground.tile_map_data,
		breakables,
		[] #TODO: Save entities
	)
