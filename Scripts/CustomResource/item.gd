class_name Item extends Resource

#region item_names

const COOL_SWORD := "cool_sword"
const STONE := "stone"
const WOOD := "wood"

#endregion

#region item_data
const _DEFAULT_ITEM_DATA : ItemData = preload("uid://4rv5ykr3xj2q")
const _ITEM_DATA : Dictionary[String,ItemData] = {
	COOL_SWORD : preload("uid://hbvcijgt3nv6"),
	STONE : preload("uid://csa57185p0hmc"),
	WOOD : preload("uid://bwekp0hhl047")
}
#endregion

enum TOOL_TYPE {NONE, FISTS, SWORD}

@export var item_name : String = WOOD
@export var item_quantity : int = 1

func is_full() -> bool:
	return item_quantity >= static_max(item_name)

func is_depleted() -> bool:
	return item_quantity <= 0


func is_tool() -> bool:
	var tool_type : TOOL_TYPE = static_tool_type(item_name)
	return (tool_type != TOOL_TYPE.NONE)

static func _get_item_data(item : String) -> ItemData:
	if item in _ITEM_DATA.keys():
		return _ITEM_DATA[item]
	return _DEFAULT_ITEM_DATA

static func static_max(item : String) -> int:
	var item_data : ItemData = _get_item_data(item)
	return item_data.get_max_amount()

static func static_tool_type(item : String) -> TOOL_TYPE:
	var item_data : ItemData = _get_item_data(item)
	assert(item_data is ItemData)
	return item_data.get_tool_type()

static func static_texture(item: String) -> Texture2D:
	var item_data : ItemData = _get_item_data(item)
	return item_data.get_icon()

func get_tool_type() -> TOOL_TYPE:
	return static_tool_type(item_name)

func get_max() -> int:
	return static_max(item_name)

func get_texture() -> Texture2D:
	return static_texture(item_name)

func add(quantity : int) -> void:
	item_quantity += quantity

func subtract(quantity : int) -> void:
	item_quantity -= quantity

func _init(_item_name : String = WOOD, _item_quantity : int = 1) -> void:
	self.item_name = _item_name
	self.item_quantity = _item_quantity

func _to_string() -> String:
	return "{name: \"%s\" count: \"%s\"}" % [item_name, str(item_quantity)]
