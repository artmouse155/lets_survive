class_name PlayerSave extends Resource

@export var player_name : String = "default_player_name"
@export var color : Color = Color.WHITE
@export var level : int = 0
@export var inventory : Array[Item] = []
@export var world_hashed_fingerprints : Dictionary[String,PackedStringArray] = {}

func get_world_hashed_fingerprints(world_name : String) -> PackedStringArray:
	if (world_name in world_hashed_fingerprints.keys()):
		return world_hashed_fingerprints[world_name]
	return []

func add_world(world_name : String, hashed_fingerprint : String) -> void:
	if (!(world_name in world_hashed_fingerprints.keys())):
		world_hashed_fingerprints[world_name] = PackedStringArray([])
	world_hashed_fingerprints[world_name].push_back(hashed_fingerprint)

## ALERT: Will save to the user folder. Be careful!
func save() -> void:
	SaveLoad.player_serializer.ser_player(self)
