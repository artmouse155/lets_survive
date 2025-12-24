class_name GameUI extends Control

@export var health_label : Label
@export var pause_screen : Control
@export var hotbar : Hotbar
@export var inventory_ui : InventoryUI
@export var chat : Chat
@export var self_brain : SelfBrain

var is_in_ingame_ui : bool = false

func _ready() -> void:
	if !self_brain:
		push_warning("No SelfBrain specified in GameUI. UI will not be able to communicate with player node.")

func _process(_delta: float) -> void:
		
	if is_in_ingame_ui:
		if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = false
			_set_self_movement_enabled(true)
			_emit_drop_all_floating()
			inventory_ui.hide()
			hotbar.show()
		elif Input.is_action_just_pressed("drop_all"):
			var touching_mouse_index := inventory_ui.get_touching_mouse_index()
			if touching_mouse_index != -1:
				_emit_drop_all_index(touching_mouse_index)
		elif Input.is_action_just_pressed("drop"):
				var touching_mouse_index := inventory_ui.get_touching_mouse_index()
				if touching_mouse_index != -1:
					_emit_drop_index(touching_mouse_index)
	else:
		if Input.is_action_just_pressed("pause"):
			set_pause(!get_tree().paused)
		elif Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = true
			_set_self_movement_enabled(false)
			inventory_ui.show()
			hotbar.hide()
			return


func set_pause(pause: bool) -> void:
	get_tree().paused = pause
	pause_screen.visible = get_tree().paused


func resume() -> void:
	set_pause(false)


func _on_player_inventory_updated(inventory : Array[Item], floating_item : Item) -> void:
	hotbar.update_hotbar(inventory.slice(0,5))
	inventory_ui.update(inventory, floating_item)


func _on_health_updated(health : float) -> void:
	health_label.text = "Health: %s" % str(health)


func _on_selected_index_updated(index : int) -> void:
	hotbar.set_selected(index)


func _on_item_collected(item : Item) -> void:
	print("Collected %s" % str(item))
	# TODO: Add toast saying "You got <item>
	pass

func _on_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_emit_drop_all_floating()
			MOUSE_BUTTON_RIGHT:
				_emit_drop_floating()


func _set_self_movement_enabled(enabled : bool) -> void:
	if self_brain:
		self_brain.set_movement_enabled(enabled)

func _emit_drop_floating() -> void:
	if self_brain:
		self_brain.emit_drop_floating()


func _emit_drop_all_floating() -> void:
	if self_brain:
		self_brain.emit_drop_all_floating()


func _emit_drop_index(index: int) -> void:
	if self_brain:
		self_brain.emit_drop_index(index)


func _emit_drop_all_index(index: int) -> void:
	if self_brain:
		self_brain.emit_drop_all_index(index)


func _on_inventory_left_clicked(index: int) -> void:
	if self_brain:
		self_brain.on_inv_slot_left_clicked(index)

func _on_inventory_right_clicked(index: int) -> void:
	if self_brain:
		self_brain.on_inv_slot_right_clicked(index)
