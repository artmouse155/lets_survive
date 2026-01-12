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


func is_player_known(player_save : PlayerSave) -> bool:
	return get_player_memory(player_save) != null

## Attempts to get the world's memory of the player.
func get_player_memory(player_save : PlayerSave) -> PlayerMemory:
	for hashed_fingerprint : String in player_save.get_world_hashed_fingerprints(_world_name):
		var memory := _get_player_memory(hashed_fingerprint)
		if memory:
			return memory
	return null
	
## ALERT: player_save will be modified to include the new fingerprint. player_save
## Must then be saved externally by resource_saver.
func add_player(player_save : PlayerSave) -> PlayerMemory:
	var hashed_fingerprint := _add_player(player_save.get_player_name())
	player_save.add_world(_world_name,hashed_fingerprint)
	return _get_player_memory(hashed_fingerprint)


func _is_player_known(hashed_fingerprint : String) -> bool:
	return _get_player_memory(hashed_fingerprint) != null

func _get_player_memory(hashed_fingerprint : String) -> PlayerMemory:
	for fingerprint : String in player_memories.keys():
		if (fingerprint.sha256_text() == hashed_fingerprint):
			return player_memories[fingerprint]
	return null

## Adds a player to player memories. Returns the SHA-256 representation of the memory.
func _add_player(player_name : String) -> String:
	var fingerprint := str(randi())
	while (fingerprint in player_memories.keys()):
		fingerprint = str(randi())
	player_memories[fingerprint] = PlayerMemory.new(player_name,_spawnpoint)
	return fingerprint.sha256_text()

func _init(world_name : String = "", world_seed : String = "") -> void:
	_world_name = world_name
	_world_seed = world_seed

## ALERT: Will save to the user folder. Be careful!
func save():
	SaveLoad.save_world(_world_name,self)
