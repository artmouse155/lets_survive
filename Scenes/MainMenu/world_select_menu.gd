class_name WorldSelectMenu extends Menu

const SelectButtonPacked : PackedScene = preload("uid://cb032osgj4mk6")
const LanSelectButtonPacked : PackedScene = preload("uid://uehrlr0ufpx6")

enum Selected {LOCAL, LAN}
var selected : Selected = Selected.LOCAL

@export var WorldButtonContainer : BoxContainer
@export var LanWorldButtonContainer : BoxContainer
@export var PlayButton : Button

var _world_name : String
var _host : String
var _port : String

signal world_selected(world_name : String)
signal lan_world_selected(host : String, port: String)

func return_to_player_select() -> void:
	menu_selected.emit(MainMenus.MENUS.CHARACTER_SELECT)

func play() -> void:
	if selected == Selected.LOCAL:
		world_selected.emit(_world_name)
	else:
		lan_world_selected.emit(_host, _port)

func create_world() -> void:
	menu_selected.emit(MainMenus.MENUS.WORLD_CREATE)

func start() -> void:
	for child : Node in WorldButtonContainer.get_children():
		child.queue_free()
	var saves := SaveLoad.world_serializer.list()
	for save : WorldSave in saves:
		var button : WorldSelectButton = SelectButtonPacked.instantiate()
		button.set_world_name(save.world_name)
		button.pressed.connect(select_world.bind(save.world_name))
		WorldButtonContainer.add_child(button)
	
	for child : Node in LanWorldButtonContainer.get_children():
		child.queue_free()
	for i in range(10):
		var button : LanWorldSelectButton = LanSelectButtonPacked.instantiate()
		button.set_data("World %d" % i, "localhost", str(6000 + i))
		button.pressed.connect(select_lan_world.bind("localhost", str(6000 + i)))
		LanWorldButtonContainer.add_child(button)
	
	PlayButton.disabled = true
	
func select_world(world_name : String) -> void:
	for child in LanWorldButtonContainer.get_children():
		if child is SelectButton:
			child.set_selected(false)
	for child in WorldButtonContainer.get_children():
		if child is WorldSelectButton:
			child.set_selected(world_name == child.internal_world_name)
	_world_name = world_name
	selected = Selected.LOCAL
	PlayButton.disabled = false

func select_lan_world(host: String, port: String) -> void:
	for child in WorldButtonContainer.get_children():
		if child is SelectButton:
			child.set_selected(false)
	for child in LanWorldButtonContainer.get_children():
		if child is LanWorldSelectButton:
			child.set_selected(host == child.internal_host and port == child.internal_port)
	_host = host
	_port = port
	selected = Selected.LAN
	PlayButton.disabled = false
