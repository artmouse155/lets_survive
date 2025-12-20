class_name SelfBrain extends PersonBrain

var is_movement_disabled : bool = false

signal drop_floating()
signal in_ui(in_ui: bool)
signal inventory_left_clicked(index: int)
signal inventory_right_clicked(index: int)

func _physics_process(_delta: float) -> void:
	
	_get_look_direction()
	if is_movement_disabled:
		return
	_get_movement_vector()
	
	if Input.is_action_pressed("attack"):
		attack.emit()
	else:
		go_idle.emit()
	if Input.is_action_just_pressed("select_0"):
		select.emit(0)
	elif Input.is_action_just_pressed("select_1"):
		select.emit(1)
	if Input.is_action_just_pressed("select_next"):
		select_next.emit()
	elif Input.is_action_just_pressed("select_prev"):
		select_prev.emit()
	if Input.is_action_just_pressed("drop_all"):
		drop_all_selected_item.emit()
	elif Input.is_action_just_pressed("drop"):
		drop_selected_item.emit()


func _get_look_direction() -> void:	
	var mouse_angle = (get_viewport().get_mouse_position() - (get_tree().get_root().size / 2.0)).angle()
	look_target.emit(mouse_angle)


func _get_movement_vector() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	movement_vector.emit(input_direction)


func set_movement_enabled(enabled : bool) -> void:
	is_movement_disabled = !enabled
	in_ui.emit(!enabled)
	if is_movement_disabled:
		movement_vector.emit(Vector2.ZERO)
		go_idle.emit()


func on_inv_slot_left_clicked(index : int) -> void:
	inventory_left_clicked.emit(index)


func on_inv_slot_right_clicked(index : int) -> void:
	inventory_right_clicked.emit(index)


func emit_drop_floating() -> void:
	drop_floating.emit()
