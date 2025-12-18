class_name Slot extends PanelContainer

@export var texture_node : TextureRect
@export var count_label : Label

var _item = null

func update(item : Item) -> void:
	_item = item
	if _item:
		texture_node.texture = _item.get_texture()
		var count = _item.item_quantity
		count_label.text = str(count) if (count > 1) else ""
	else:
		texture_node.texture = null
		count_label.text = ""

func get_item() -> Item:
	return _item
