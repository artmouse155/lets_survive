class_name PlayerPreview extends SubViewportContainer

@export var player : PlayerEntity

func preview(player_save : PlayerSave) -> void:
	player.set_color(player_save.get_color())
