class_name WorldSelectMenu extends Menu

const SelectButtonPacked : PackedScene = preload("uid://cb032osgj4mk6")

@export var WorldButtonContainer : BoxContainer
@export var PlayButton : Button

var _world_name : String

signal world_selected(world_index : int)

func return_to_player_select():
	menu_selected.emit(MainMenus.MENUS.CHARACTER_SELECT)

func play():
	world_selected.emit(_world_name)

func create_world():
	menu_selected.emit(MainMenus.MENUS.WORLD_CREATE)

func start() -> void:
	for child : Node in WorldButtonContainer.get_children():
		child.queue_free()
	var saves := SaveLoad.get_world_saves()
	for save : WorldSave in saves:
		var button : WorldSelectButton = SelectButtonPacked.instantiate()
		button.set_world_name(save.get_world_name())
		button.pressed.connect(select_world.bind(save.get_world_name()))
		WorldButtonContainer.add_child(button)
	PlayButton.disabled = true
	
func select_world(world_name : String):
	_world_name = world_name
	PlayButton.disabled = false
