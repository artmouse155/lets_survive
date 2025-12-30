class_name ItemData extends Resource

const _DEFAULT_ITEM_DATA : ItemData = preload("uid://4rv5ykr3xj2q")

#region item_data
const _DATA : Dictionary[String,ItemData] = {
	Item.WOOD : preload("uid://bwekp0hhl047"),
	Item.STONE : preload("uid://csa57185p0hmc"),
	Item.COOL_SWORD : preload("uid://hbvcijgt3nv6")
}
#endregion

@export var _icon : Texture2D = null
@export var _max_amount : int = 10

func get_icon() -> Texture2D:
	return _icon

func get_max_amount() -> int:
	return _max_amount

func get_tool_type() -> Item.TOOL_TYPE:
	return Item.TOOL_TYPE.NONE

static func of(item : String) -> ItemData:
	if item in _DATA.keys():
		return _DATA[item]
	return _DEFAULT_ITEM_DATA
