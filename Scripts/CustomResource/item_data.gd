class_name ItemData extends Resource

@export var _icon : Texture2D = null
@export var _max_amount : int = 10

func get_icon() -> Texture2D:
	return _icon

func get_max_amount() -> int:
	return _max_amount

func get_tool_type() -> Item.TOOL_TYPE:
	return Item.TOOL_TYPE.NONE
