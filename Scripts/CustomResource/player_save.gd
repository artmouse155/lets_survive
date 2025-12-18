class_name PlayerSave extends Resource

@export var _player_name : String
@export var _color : Color
@export var _level : int = 0

func get_player_name() -> String:
	return _player_name

func get_level() -> int:
	return _level

func _init(player_name : String = "", color : Color = Color.WHITE) -> void:
	_player_name = player_name
	_color = color
