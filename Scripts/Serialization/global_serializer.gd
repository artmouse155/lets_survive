class_name GlobalSerializer
extends Serializer

const GLOBAL_SAVE_NAME = "global_save"

func _init() -> void:
	super._init(USER_DIR)


func ser(global_save : RefCounted) -> void:
	_ser(GLOBAL_SAVE_NAME, global_save)


func des() -> RefCounted:
	return _des(GLOBAL_SAVE_NAME) as RefCounted


func list() -> Array[String]:
	return _list(ListType.FILES)
