class_name ChunkSave
extends Resource

var _coordinates : Vector2i
var _ground_tile_map_data: PackedByteArray
var _above_ground_tile_map_data: PackedByteArray
var _breakables: Array[Breakable]
var _entities: Array[Entity]

func _init(
	coordinates: Vector2i,
	ground_tile_map_data: PackedByteArray,
	above_ground_tile_map_data: PackedByteArray,
	breakables: Array[Breakable],
	entities: Array[Entity]
	) -> void:
	_coordinates = coordinates
	_ground_tile_map_data = ground_tile_map_data
	_above_ground_tile_map_data = above_ground_tile_map_data
	_breakables = breakables
	_entities = entities


func get_coordinates() -> Vector2i:
	return _coordinates


func get_ground_tile_map_data() -> PackedByteArray:
	return _ground_tile_map_data


func get_above_ground_tile_map_data() -> PackedByteArray:
	return _above_ground_tile_map_data


func get_breakables() -> Array[Breakable]:
	return _breakables


func get_entities() -> Array[Entity]:
	return _entities
