class_name SelectButton extends PanelContainer

@export var SelectedPanel : Control

signal pressed

func emit_pressed() -> void:
	pressed.emit()

func set_selected(s: bool) -> void:
	SelectedPanel.visible = s
