class_name World extends Node2D

@export var terrain_gen : FastNoiseLite
@export var tree_gen : FastNoiseLite

@export var ground : TileMapLayer
@export var above_ground : TileMapLayer

@export var entity_spawner : EntitySpawner

const PACKED_TREE : PackedScene = preload("uid://dg8ianfbwidj5")

const WATER_ATLAS = Vector2i(2,0)
const GRASS_ATLAS = Vector2i(0,0)
const SAND_ATLAS = Vector2i(1,0)

func start(world_seed : String, player_save : PlayerSave) -> void:
	generate_world(world_seed)
	entity_spawner.spawn_player(player_save,true)

func generate_world(world_seed : String):
	var world_size_x : int = 200
	var world_size_y : int = 200
	var seed_int : int = world_seed.hash()
	terrain_gen.seed = seed_int
	var random := RandomNumberGenerator.new()
	random.seed = seed_int
	for x in range(world_size_x):
		for y in range(world_size_y):
			var noise_val : float = terrain_gen.get_noise_2d(x,y)
			var tile_atlas := _noise_to_atlas(noise_val)
			ground.set_cell(Vector2i(x,y),0, tile_atlas)
			if (noise_val < .1) && (random.randf() < .1):
				_spawn_tree(ground.map_to_local(Vector2i(x,y)))

func _spawn_tree(coords : Vector2) -> void:
	var tree : Breakable = PACKED_TREE.instantiate()
	tree.position = coords
	tree.world_item_dropped.connect(entity_spawner.on_world_item_dropped)
	add_child(tree)


static func _noise_to_atlas(noise_val : float) -> Vector2i:
	if (noise_val < .2):
		return GRASS_ATLAS
	elif (noise_val < .25):
		return SAND_ATLAS
	return WATER_ATLAS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
