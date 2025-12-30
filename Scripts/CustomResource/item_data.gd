class_name ItemData extends Resource

@export var _icon : Texture2D = null
@export var _max_amount : int = 10
@export var _tool_type : Item.TOOL_TYPE = Item.TOOL_TYPE.NONE

func get_icon() -> Texture2D:
	return _icon

func get_max_amount() -> int:
	return _max_amount

func get_tool_type() -> Item.TOOL_TYPE:
	return _tool_type
