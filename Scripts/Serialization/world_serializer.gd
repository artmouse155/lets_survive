class_name WorldSerializer
extends Serializer

const WORLD_SAVE_NAME = "world_save"

func _init() -> void:
	super._init("%s%s" % [USER_DIR, WORLD_SUB_DIR])


func ser_world(world_save : WorldSave) -> void:
	var error := DirAccess.make_dir_absolute("%s/%s" % [directory, world_save.world_name])
	if error == OK || error == ERR_ALREADY_EXISTS:
		_ser("%s/%s" % [world_save.world_name, WORLD_SAVE_NAME], world_save)
		return
	push_error(error_string(error))


func des_world(world_name : String) -> WorldSave:
	return _des("%s/%s" % [world_name, WORLD_SAVE_NAME]) as WorldSave


func list() -> Array[WorldSave]:
	var save_names := _list(ListType.DIRECTORIES)
	var output : Array[WorldSave]
	for s in save_names:
		output.append(des_world(s))
	return output
