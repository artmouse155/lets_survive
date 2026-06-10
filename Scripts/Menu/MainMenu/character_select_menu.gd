class_name CharacterSelectMenu extends Menu

const SelectButtonPacked : PackedScene = preload("uid://ckcx2xvk8cpir")

@export var CharacterButtonContainer : BoxContainer
@export var PlayButton : Button
@export var PreviewBox : PlayerPreview

signal character_selected(player_name : String)

func return_to_main_menu() -> void:
	menu_selected.emit(MainMenus.MENUS.TITLE)

func play() -> void:
	menu_selected.emit(MainMenus.MENUS.WORLD_SELECT)
	
func create_character() -> void:
	menu_selected.emit(MainMenus.MENUS.CHARACTER_CREATE)

func start() -> void:
	for child in CharacterButtonContainer.get_children():
		child.queue_free()
	var saves := SaveLoad.player_serializer.list()
	for save : PlayerSave in saves:
		var button : CharacterSelectButton = SelectButtonPacked.instantiate()
		button.set_character_name(save.player_name)
		button.set_character_level(save.level)
		button.pressed.connect(select_character.bind(save.player_name))
		CharacterButtonContainer.add_child(button)
	PreviewBox.preview(null)
	PlayButton.disabled = true
	
func select_character(player_name : String) -> void:
	for child in CharacterButtonContainer.get_children():
		if child is CharacterSelectButton:
			child.set_selected(player_name == child.internal_character_name)
	character_selected.emit(player_name)
	PlayButton.disabled = false
	PreviewBox.preview(SaveLoad.player_serializer.des_player(player_name))
