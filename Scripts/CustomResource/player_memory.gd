class_name PlayerMemory extends Resource

@export var _player_name : String
@export var _position : Vector2

func _init(player_name : String = "", position : Vector2 = Vector2.ZERO) -> void:
	_player_name = player_name
	_position = position
