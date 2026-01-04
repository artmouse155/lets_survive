class_name MainMenus extends Control

enum MENUS {TITLE, SETTINGS, CHARACTER_SELECT, CHARACTER_CREATE, WORLD_SELECT, WORLD_CREATE, GAME}

@export var menus : Dictionary[MENUS,Menu]

@export var characterSelectNode : CharacterSelectMenu
@export var worldSelectNode : WorldSelectMenu
@export var gameContainer : GameContainer

var _current_player_name : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for menu : Menu in menus.values():
		menu.menu_selected.connect(set_menu)
	set_menu(MENUS.TITLE)

func set_menu(menu : MENUS) -> void:
	for key in menus.keys():
		menus[key].visible = (key == menu)
		if (key == menu):
			menus[key].start()

func set_current_player_name(player_name : String) -> void:
	_current_player_name = player_name

func load_game(world_name : String) -> void:
	gameContainer.loadGame(world_name, _current_player_name)
	set_menu(MENUS.GAME)
