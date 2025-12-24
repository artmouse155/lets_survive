@abstract
class_name PlayerBrain extends PersonBrain

var is_movement_disabled : bool = false

signal drop_floating()
signal drop_all_floating()
signal in_ui(in_ui: bool)
signal inventory_left_clicked(index: int)
signal inventory_right_clicked(index: int)

func set_movement_enabled(enabled : bool) -> void:
	is_movement_disabled = !enabled
	_emit(in_ui,!enabled)
	if is_movement_disabled:
		_emit(movement_vector,Vector2.ZERO)
		_emit(go_idle)


func on_inv_slot_left_clicked(index : int) -> void:
	_emit(inventory_left_clicked, index)


func on_inv_slot_right_clicked(index : int) -> void:
	_emit(inventory_right_clicked, index)


func emit_drop_floating() -> void:
	_emit(drop_floating)


func emit_drop_all_floating() -> void:
	_emit(drop_all_floating)
