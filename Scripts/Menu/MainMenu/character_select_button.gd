class_name CharacterSelectButton extends PanelContainer

@export var NameLabel : Label
@export var LevelLabel : Label

signal pressed

func set_character_name(character_name : String):
	NameLabel.text = character_name

func set_character_level(character_level : int):
	LevelLabel.text = "Lv. %s" % str(character_level)

func emit_pressed():
	pressed.emit()
