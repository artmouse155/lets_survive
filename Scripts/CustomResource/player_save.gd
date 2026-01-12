class_name PlayerSave extends Resource

@export var _player_name : String
@export var _color : Color
@export var _level : int = 0
@export var _inventory : Array[Item]

var _world_hashed_fingerprints : Dictionary[String,PackedStringArray] = {}

func get_player_name() -> String:
	return _player_name

func get_level() -> int:
	return _level

func get_color() -> Color:
	return _color

func get_inventory() -> Array[Item]:
	return _inventory

func set_inventory(i : Array[Item]) -> void:
	_inventory = i

func get_world_hashed_fingerprints(world_name : String) -> PackedStringArray:
	if (world_name in _world_hashed_fingerprints.keys()):
		return _world_hashed_fingerprints[world_name]
	return []

func add_world(world_name : String, hashed_fingerprint : String) -> void:
	if (!(world_name in _world_hashed_fingerprints.keys())):
		_world_hashed_fingerprints[world_name] = PackedStringArray([])
	_world_hashed_fingerprints[world_name].push_back(hashed_fingerprint)


func _init(player_name : String = "", color : Color = Color.WHITE) -> void:
	_player_name = player_name
	_color = color

## ALERT: Will save to the user folder. Be careful!
func save():
	SaveLoad.save_player(_player_name,self)
