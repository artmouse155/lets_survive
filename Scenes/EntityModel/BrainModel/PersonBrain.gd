class_name PersonBrain extends Brain

signal movement_vector(direction : Vector2)
signal look_target(angle : float)

signal attack()
signal go_idle()
# TODO: Server side should make sure selection is within hotbar
signal select(index: int)
signal select_next()
signal select_prev()

signal drop_all_selected_item()
signal drop_selected_item()
signal drop_index(index: int)
signal drop_all_index(index: int)

func emit_drop_index(index: int):
	drop_index.emit(index)


func emit_drop_all_index(index: int):
	drop_all_index.emit(index)
