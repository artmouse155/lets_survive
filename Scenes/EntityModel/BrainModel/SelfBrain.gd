class_name SelfBrain extends Brain

var is_movement_disabled : bool = false

signal movement_vector(direction : Vector2)
signal look_direction(angle_rad : float)

signal attack()
signal go_idle()
# TODO: Server side should make sure selection is within hotbar
signal select(index: int)
signal select_next()
signal select_prev()

signal drop_all_selected_item()
signal drop_selected_item()

func _get_input():
	
	if is_movement_disabled:
		return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	movement_vector.emit(input_direction)
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
		#if sprite.get_selected_index() >= (HOTBAR_SIZE - 1):
			#select.emit(0)
		#else:
			#select.emit(sprite.get_selected_index() + 1)
	elif Input.is_action_just_pressed("select_prev"):
		select_prev.emit()
		#if sprite.get_selected_index() <= (0):
			#_select(HOTBAR_SIZE - 1)
		#else:
			#_select(sprite.get_selected_index() - 1)
	if Input.is_action_just_pressed("drop_all_selected_item"):
		drop_all_selected_item.emit()
	elif Input.is_action_just_pressed("drop_selected_item"):
		drop_selected_item.emit()

func _get_look_direction() -> void:	
	var mouse_angle = get_viewport().get_mouse_position().angle()
	look_direction.emit(mouse_angle)

#func _physics_process(_delta):
	#_get_input()
	#_get_look_direction()
	#move_and_slide()

#func set_movement_enabled(enabled : bool) -> void:
	#is_movement_disabled = !enabled
	#if is_movement_disabled:
		#velocity = Vector2.ZERO
		#sprite.go_idle()
