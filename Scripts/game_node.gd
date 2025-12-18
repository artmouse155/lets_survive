class_name GameContainer extends Menu

@export var world : World

signal set_pause(pause : bool)

func return_to_main_menu():
	set_pause.emit(false)
	menu_selected.emit(MainMenus.MENUS.TITLE)

func loadGame(world_index : int, player_index : int) -> void:
	var player_data := SaveLoad.get_player_save(player_index)
	print(player_data)
	var world_data := SaveLoad.get_world_save(world_index)
	world.generate_world(world_data.get_world_seed())

func testLoad(world_seed : String) -> void:
	world.generate_world(world_seed)
