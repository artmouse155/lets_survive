class_name GameContainer extends Menu

@export var world : World
@export var game_ui : GameUI
@export var save_button : Button
@export var connection_bus : ConnectionBus

@export var load_screen : Control
@export var load_screen_text : RichTextLabel
@export var load_screen_button : Button

@export var open_to_lan_button : Button

signal join_lan(host: String, port: String)
signal back_from_lan(host: String, port: String)

func start() -> void:
	open_to_lan_button.disabled = false


func return_to_main_menu() -> void:
	game_ui.set_pause(false)
	world.clear()
	connection_bus.remove_multiplayer_peer()
	menu_selected.emit(MainMenus.MENUS.TITLE)

func loadGame(world_name : String, player_name : String) -> void:
	var player_save := SaveLoad.get_player_save(player_name)
	print("Player Save Path: %s" % player_save.resource_path)
	var world_data := SaveLoad.get_world_save(world_name)
	if (save_button.pressed.is_connected(save)):
		save_button.pressed.disconnect(save)
	save_button.pressed.connect(save.bind(world_name,player_name))
	load_screen.hide()
	world.start(world_data, player_save)

func load_lan_game(host: String, port: String, player_name : String) -> void:
	var player_save := SaveLoad.get_player_save(player_name)
	print("Player Save Path: %s" % player_save.resource_path)
	if (save_button.pressed.is_connected(save)):
		save_button.pressed.disconnect(save)
	if (load_screen_button.pressed.is_connected(_on_back_from_lan_button_pressed)):
		load_screen_button.pressed.disconnect(_on_back_from_lan_button_pressed)
	load_screen_button.pressed.connect(_on_back_from_lan_button_pressed.bind(host,port))
	load_screen_text.text = "Connecting..."
	load_screen.show()
	join_lan.emit(host,port)

func testLoad(world_save : WorldSave, player_save : PlayerSave) -> void:
	world.start(world_save, player_save)

func save(_world_name : String, player_name : String) -> void:
	SaveLoad.save_player(player_name, world.get_updated_self_save())

func _on_back_from_lan_button_pressed(host: String, port: String) -> void:
	game_ui.set_pause(false)
	connection_bus.remove_multiplayer_peer()
	back_from_lan.emit(host,port)
