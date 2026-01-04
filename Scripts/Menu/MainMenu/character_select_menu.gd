class_name CharacterSelectMenu extends Menu

const SelectButtonPacked : PackedScene = preload("uid://ckcx2xvk8cpir")

@export var CharacterButtonContainer : BoxContainer
@export var PlayButton : Button
@export var PreviewBox : PlayerPreview

signal character_selected(player_name : String)

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
	for save : PlayerSave in saves:
		var button : CharacterSelectButton = SelectButtonPacked.instantiate()
		button.set_character_name(save.get_player_name())
		button.set_character_level(save.get_level())
		button.pressed.connect(select_character.bind(save.get_player_name()))
		CharacterButtonContainer.add_child(button)
	PreviewBox.preview(null)
	PlayButton.disabled = true
	
func select_character(player_name : String):
	character_selected.emit(player_name)
	PlayButton.disabled = false
	PreviewBox.preview(SaveLoad.get_player_save(player_name))
	# TODO: Make preview show up
