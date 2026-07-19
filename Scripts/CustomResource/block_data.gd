class_name BlockData extends Resource

@export var atlas : Vector2i
@export var source_id : int

const AIR : StringName = &"air"
const _BACKUP_BLOCK : StringName = &"grass"

# We have to use `load` instead of `preload` here because `preload` assumes the script
# itself is already loaded. Because we are loading a `BlockData`, this does not work correctly.
static var _block_data : Dictionary[StringName,BlockData] = {
	&"grass" : load("uid://dfras14tehstb") as BlockData,
	&"sand" : load("uid://b52myo1vclp50") as BlockData,
	&"water" : load("uid://bo0ljasodv0hu") as BlockData
}

static func block_data(block : StringName) -> BlockData:
	if block in _block_data.keys():
		return _block_data[block]
	if block != AIR:
		push_warning("Block \"%s\" not found" % block)
	return null
