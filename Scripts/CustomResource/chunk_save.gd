class_name ChunkSave
extends Resource

var coordinates : Vector2i
var ground_block_grid: BlockGrid
var above_ground_block_grid: BlockGrid
var breakables: Array[Breakable]
var entities: Array[Entity]


static func c_to_s(coords : Vector2i) -> String:
	return "%s %s" % [str(coords.x), str(coords.y)]
