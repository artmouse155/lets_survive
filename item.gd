class_name Item extends Resource

enum ITEM {WOOD, STONE, COOL_SWORD}

enum TOOL_TYPE {NONE, FISTS, SWORD}

const MAX_AMOUNTS : Dictionary[ITEM,int] = {
	ITEM.WOOD: 10,
	ITEM.STONE: 10,
	ITEM.COOL_SWORD: 1
}

const TOOLS : Dictionary[ITEM, TOOL_TYPE] = {
	ITEM.COOL_SWORD : TOOL_TYPE.SWORD
	}

const TEXTURES : Dictionary[ITEM, Texture2D] = {
	ITEM.WOOD : preload("uid://bsifbn1s8va8o"),
	ITEM.STONE : preload("uid://bfnhf5fvnfvc6"),
	ITEM.COOL_SWORD : preload("uid://vdpl0cs1odtg")
}

@export var item_name : ITEM = ITEM.WOOD
@export var item_quantity : int = 1

func is_full() -> bool:
	return item_quantity >= static_max(item_name)

func is_depleted() -> bool:
	return item_quantity <= 0

func is_tool() -> bool:
	var tool_type : TOOL_TYPE = static_tool_type(item_name)
	return (tool_type != TOOL_TYPE.NONE)

static func static_max(item : ITEM) -> int:
	return MAX_AMOUNTS[item]

static func static_tool_type(item : ITEM) -> TOOL_TYPE:
	if item in TOOLS.keys():
		return TOOLS[item]
	return TOOL_TYPE.NONE

static func static_texture(item: ITEM) -> Texture2D:
	return TEXTURES[item]

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

func _init(_item_name : ITEM = ITEM.WOOD, _item_quantity : int = 1) -> void:
	self.item_name = _item_name
	self.item_quantity = _item_quantity

func _to_string() -> String:
	return "{name: \"%s\" count: \"%s\"}" % [ITEM.keys()[item_name], str(item_quantity)]
