extends Control

@export var player_save : PlayerSave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameContainer.testLoad("waterplz", player_save)

func _exit(_menu: MainMenus.MENUS) -> void:
	get_tree().quit()
