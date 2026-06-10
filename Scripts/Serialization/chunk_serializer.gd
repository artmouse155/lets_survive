class_name ChunkSerializer
extends Serializer

const CHUNK_SUB_DIR = "chunks"

func _init(world_name : String) -> void:
	super._init("%s%s/%s/%s" % [USER_DIR, WORLD_SUB_DIR, world_name, CHUNK_SUB_DIR])


func ser_chunk(chunk_save : ChunkSave) -> void:
	_ser(ChunkSave.c_to_s(chunk_save.coordinates), chunk_save)


func des_chunk(coords : Vector2i) -> ChunkSave:
	return _des(ChunkSave.c_to_s(coords)) as ChunkSave
