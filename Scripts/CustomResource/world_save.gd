class_name WorldSave extends Resource

@export var _world_name : String = ""
@export var _world_seed : String = ""

var chunks : Dictionary[Vector2i,Chunk]

func get_world_name() -> String:
	return _world_name

func get_world_seed() -> String:
	return _world_seed

func _init(world_name : String = "", world_seed : String = "") -> void:
	_world_name = world_name
	_world_seed = world_seed
