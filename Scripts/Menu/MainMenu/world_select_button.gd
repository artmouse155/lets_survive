class_name WorldSelectButton extends SelectButton

@export var label : Label

var internal_world_name := ""

func set_world_name(world_name : String) -> void:
	internal_world_name = world_name
	label.text = world_name
