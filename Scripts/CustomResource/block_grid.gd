class_name BlockGrid extends Resource

# export_storage means stored in the file but not the editor.
@export_storage var data : Array[PackedStringArray] = []

func _init() -> void:
	for i in range(World.CHUNK_SIZE.x):
		data.push_back([])
		for j in range(World.CHUNK_SIZE.y):
			data[i].push_back(BlockData.AIR)

func set_block(coordinate: Vector2i, block: StringName) -> void:
	validate_coordinate(coordinate)
	data[coordinate.x][coordinate.y] = str(block)

func get_block(coordinate: Vector2i) -> StringName:
	validate_coordinate(coordinate)
	return data[coordinate.x][coordinate.y]

func validate_coordinate(coordinate: Vector2i) -> void:
	if ((coordinate.x >= 0) and 
		(coordinate.y >= 0) and 
		(coordinate.x < World.CHUNK_SIZE.x) and 
		(coordinate.y < World.CHUNK_SIZE.y)):
		return
	push_error("Coordinates %v outside of boundaries %v and %v" % [coordinate, Vector2.ZERO, World.CHUNK_SIZE])
