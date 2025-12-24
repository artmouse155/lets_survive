class_name Hotbar extends PanelContainer

var _slots : Array[HotbarSlot]
@export var slot_container : BoxContainer

func update_hotbar(items : Array[Item]) -> void:
	if !_slots:
		_slots = get_slots()
	for i in range(len(_slots)):
		_slots[i].update(items[i])

func set_selected(index : int) -> void:
	for i in range(len(_slots)):
		_slots[i].set_selected(i == index)

func get_slots() -> Array[HotbarSlot]:
	var output : Array[HotbarSlot]
	for child in slot_container.get_children():
		if is_instance_of(child,HotbarSlot):
			output.append(child)
	return output
