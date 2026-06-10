extends Node

const NAMING_REGEX = "[a-zA-Z _\\d]{1,}"

@onready var player_serializer := PlayerSerializer.new()
@onready var world_serializer := WorldSerializer.new()
@onready var global_serializer := GlobalSerializer.new()

func get_chunk_serializer(world_name : String) -> ChunkSerializer:
	return ChunkSerializer.new(world_name)

func save_chunks(world_name : String, chunks : Array[ChunkSave]) -> void:
	var chunk_serializer := ChunkSerializer.new(world_name)
	for chunk in chunks:
		chunk_serializer.ser_chunk(chunk)
