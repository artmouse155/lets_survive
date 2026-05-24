extends Control

@export var world_save : WorldSave
@export var player_save : PlayerSave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameContainer.testLoad(world_save, player_save)

func _exit(_menu: MainMenus.MENUS) -> void:
	get_tree().quit()


func _on_game_container_back_from_lan(_host: String, _port: String) -> void:
	get_tree().quit()
