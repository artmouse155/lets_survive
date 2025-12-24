class_name WorldSelectButton extends PanelContainer

@export var label : Label

signal pressed

func set_world_name(world_name : String) -> void:
	label.text = world_name

func emit_pressed():
	pressed.emit()
