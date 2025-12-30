class_name CharacterSelectMenu extends Menu

const SelectButtonPacked : PackedScene = preload("uid://ckcx2xvk8cpir")

@export var CharacterButtonContainer : BoxContainer
@export var PlayButton : Button
@export var PreviewBox : PlayerPreview

signal character_selected(index : int)

func return_to_main_menu():
	menu_selected.emit(MainMenus.MENUS.TITLE)

func play():
	menu_selected.emit(MainMenus.MENUS.WORLD_SELECT)
	
func create_character():
	menu_selected.emit(MainMenus.MENUS.CHARACTER_CREATE)

func start() -> void:
	for child in CharacterButtonContainer.get_children():
		child.queue_free()
	var saves := SaveLoad.get_player_saves()
	for i : int in range(len(saves)):
		var save = saves[i]
		var button : CharacterSelectButton = SelectButtonPacked.instantiate()
		button.set_character_name(save.get_player_name())
		button.set_character_level(save.get_level())
		button.pressed.connect(select_character.bind(i))
		CharacterButtonContainer.add_child(button)
	PreviewBox.preview(null)
	PlayButton.disabled = true
	
func select_character(index : int):
	character_selected.emit(index)
	PlayButton.disabled = false
	PreviewBox.preview(SaveLoad.get_player_save(index))
	# TODO: Make preview show up
