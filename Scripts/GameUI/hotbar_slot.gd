class_name HotbarSlot extends Slot

@export var selected : Control

func set_selected(is_selected : bool) -> void:
	selected.visible = is_selected
