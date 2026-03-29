class_name PauseMenus extends Control

enum MENUS {PAUSE, HOST_LAN, SETTINGS, ACHIEVEMENTS}

@export var menus : Dictionary[MENUS,Menu]
@export var game_ui : GameUI

#func _process(_delta: float) -> void:
	#
	#if !is_visible_in_tree():
		#return
	#
	#if Input.is_action_just_pressed("pause") and get_tree().paused:
		#unpause()

func set_menu(menu : MENUS) -> void:
	for key: MENUS in menus.keys():
		menus[key].visible = (key == menu)
		if (key == menu):
			menus[key].start()

func set_menu_pause_screen() -> void:
	set_menu(MENUS.PAUSE)

func set_menu_host_lan() -> void:
	set_menu(MENUS.HOST_LAN)
	
func set_menu_settings() -> void:
	set_menu(MENUS.SETTINGS)
	
func set_menu_achievements() -> void:
	set_menu(MENUS.ACHIEVEMENTS)

func unpause() -> void:
	game_ui.set_pause(false)
