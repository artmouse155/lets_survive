class_name PlayerPreview extends SubViewportContainer

@export var player : PlayerEntity

func preview(player_save : PlayerSave) -> void:
	if player_save:
		player.set_inventory(player_save.get_inventory())
		player.set_color(player_save.get_color())
		player.show()
	else:
		player.hide()
