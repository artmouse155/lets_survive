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
		_emit(attack)
	else:
		_emit(go_idle)
	if Input.is_action_just_pressed("select_0"):
		_emit(select,0)
	elif Input.is_action_just_pressed("select_1"):
		_emit(select,1)
	if Input.is_action_just_pressed("select_next"):
		_emit(select_next)
	elif Input.is_action_just_pressed("select_prev"):
		_emit(select_prev)
	if Input.is_action_just_pressed("drop_all"):
		_emit(drop_all_selected_item)
	elif Input.is_action_just_pressed("drop"):
		_emit(drop_selected_item)


func _get_look_direction() -> void:	
	var mouse_angle = (get_viewport().get_mouse_position() - (get_tree().get_root().size / 2.0)).angle()
	_emit(look_target,mouse_angle)


func _get_movement_vector() -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	_emit(movement_vector,input_direction)


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
