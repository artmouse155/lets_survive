class_name UISlot extends Slot

signal left_click
signal right_click

#var is_under_mouse = false

func _on_button_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				left_click.emit()
			MOUSE_BUTTON_RIGHT:
				right_click.emit()

func is_under_mouse() -> bool:
	return visible and Rect2(Vector2.ZERO,size).has_point(get_local_mouse_position())
