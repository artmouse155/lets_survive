class_name ChunkSave
extends Resource

var coordinates : Vector2i
var ground_tile_map_data: PackedByteArray
var above_ground_tile_map_data: PackedByteArray
var breakables: Array[Breakable]
var entities: Array[Entity]

#func _init(
	#coordinates: Vector2i,
	#ground_tile_map_data: PackedByteArray,
	#above_ground_tile_map_data: PackedByteArray,
	#breakables: Array[Breakable],
	#entities: Array[Entity]
	#) -> void:
	#_coordinates = coordinates
	#_ground_tile_map_data = ground_tile_map_data
	#_above_ground_tile_map_data = above_ground_tile_map_data
	#_breakables = breakables
	#_entities = entities


static func c_to_s(coords : Vector2i) -> String:
	return "%s %s" % [str(coords.x), str(coords.y)]
