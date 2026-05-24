class_name GameContainer extends Menu

@export var world : World
@export var game_ui : GameUI
@export var save_button : Button

const GAME_MUSIC : AudioStream = preload("uid://be781y8ixix8a")

func start() -> void:
	pass


func return_to_main_menu() -> void:
	game_ui.set_pause(false)
	world.clear()
	menu_selected.emit(MainMenus.MENUS.TITLE)

func loadGame(world_name : String, player_name : String) -> void:
	AudioBus.play_song(GAME_MUSIC)
	var player_save := SaveLoad.get_player_save(player_name)
	print("Player Save Path: %s" % player_save.resource_path)
	var world_data := SaveLoad.get_world_save(world_name)
	if (save_button.pressed.is_connected(save)):
		save_button.pressed.disconnect(save)
	save_button.pressed.connect(save.bind(world_name,player_name))
	world.start(world_data, player_save)

func testLoad(world_save : WorldSave, player_save : PlayerSave) -> void:
	world.start(world_save, player_save)

func save(_world_name : String, player_name : String) -> void:
	SaveLoad.save_player(player_name, world.get_updated_self_save())
	
