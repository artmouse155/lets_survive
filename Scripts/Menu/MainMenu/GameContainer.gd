class_name GameContainer extends Menu

@export var world : World
@export var game_ui : GameUI

func start() -> void:
	pass

func return_to_main_menu():
	game_ui.set_pause(false)
	world.clear()
	menu_selected.emit(MainMenus.MENUS.TITLE)

func loadGame(world_name : String, player_name : String) -> void:
	var player_save := SaveLoad.get_player_save(player_name)
	print("Player Save Path: %s" % player_save.resource_path)
	var world_data := SaveLoad.get_world_save(world_name)
	world.start(world_data.get_world_seed(), player_save)

func testLoad(world_seed : String, player_save : PlayerSave) -> void:
	world.start(world_seed, player_save)
