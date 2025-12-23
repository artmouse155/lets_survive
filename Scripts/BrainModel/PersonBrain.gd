class_name PersonBrain extends Brain

@warning_ignore_start("unused_signal")
signal movement_vector(direction : Vector2)
signal look_target(angle : float)

signal attack()
signal go_idle()
# TODO: Server side should make sure selection is within hotbar
signal select(index: int)
signal select_next()
signal select_prev()

signal drop_selected_item()
signal drop_all_selected_item()
signal drop_index(index: int)
signal drop_all_index(index: int)
@warning_ignore_restore("unused_signal")

func emit_drop_index(index: int):
	_emit(drop_index,index)


func emit_drop_all_index(index: int):
	_emit(drop_all_index,index)
