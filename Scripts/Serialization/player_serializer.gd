class_name PlayerSerializer
extends Serializer

const PLAYER_SUB_DIR = "player_saves"

func _init() -> void:
	super._init("%s%s" % [USER_DIR, PLAYER_SUB_DIR])


func ser_player(player_save : PlayerSave) -> void:
	_ser(player_save.player_name, player_save)


func des_player(player_name : String) -> PlayerSave:
		return _des(player_name) as PlayerSave


func list() -> Array[PlayerSave]:
	var save_names := _list(ListType.FILES)
	var output : Array[PlayerSave]
	for s in save_names:
		output.append(des_player(s.trim_suffix(FILE_TYPE)))
	return output
