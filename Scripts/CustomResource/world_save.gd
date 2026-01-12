class_name WorldSave extends Resource

@export var _world_name : String = ""
@export var _world_seed : String = ""
@export var _spawnpoint : Vector2i = Vector2i.ZERO

var chunks : Dictionary[Vector2i,Chunk]

# Dictionary[Player Fingerprint, Memory]
var player_memories : Dictionary[String,PlayerMemory] = {}

func get_world_name() -> String:
	return _world_name

func get_world_seed() -> String:
	return _world_seed

func get_spawnpoint() -> Vector2i:
	return _spawnpoint

func is_player_known(hashed_fingerprint : String) -> bool:
	return get_player_memory(hashed_fingerprint) != null

func get_player_memory(hashed_fingerprint : String) -> PlayerMemory:
	for fingerprint : String in player_memories.keys():
		if (fingerprint.sha256_text() == hashed_fingerprint):
			return player_memories[fingerprint]
	return null

## Adds a player to player memories. Returns the SHA-256 representation of the memory.
func add_player(player_name : String) -> String:
	var fingerprint := str(randi())
	while (not fingerprint in player_memories.keys()):
		fingerprint = str(randi())
	player_memories[fingerprint] = PlayerMemory.new(player_name,_spawnpoint)
	return fingerprint.sha256_text()

func _init(world_name : String = "", world_seed : String = "") -> void:
	_world_name = world_name
	_world_seed = world_seed
