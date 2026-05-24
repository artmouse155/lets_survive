class_name CharacterSelectButton extends SelectButton

@export var NameLabel : Label
@export var LevelLabel : Label

var internal_character_name := ""

func set_character_name(character_name : String) -> void:
	internal_character_name = character_name
	NameLabel.text = character_name

func set_character_level(character_level : int) -> void:
	LevelLabel.text = "Lv. %s" % str(character_level)
