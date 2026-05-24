class_name LanWorldSelectButton extends SelectButton

@export var WorldLabel : Label
@export var button : Button

var internal_world_name := ""
var internal_host := ""
var internal_port := ""

func set_data(world_name : String, host: String, port: String) -> void:
	internal_host = host
	internal_port = port
	internal_world_name = world_name
	button.tooltip_text = "Host: %s\nPort: %s" % [host, port]
	WorldLabel.text = world_name
