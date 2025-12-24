class_name PauseMenus extends Control

enum MENUS {PAUSE, HOST_LAN, SETTINGS, ACHIEVEMENTS}

@export var menus : Dictionary[MENUS,Menu]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_menu(menu : MENUS) -> void:
	for key in menus.keys():
		menus[key].visible = (key == menu)
		if (key == menu):
			menus[key].start()
