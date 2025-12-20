extends Control

@export var player_save : PlayerSave

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GameContainer.testLoad("0", player_save)
