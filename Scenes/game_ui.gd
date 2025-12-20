extends Control

@export var health_label : Label
@export var inventory_label : Label

@export var pause_screen : Control
@export var hotbar : Hotbar
@export var inventory_ui : InventoryUI
@export var self_brain : SelfBrain

var is_in_ingame_ui : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
		
	if is_in_ingame_ui:
		if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = false
			self_brain.set_movement_enabled(true)
			_drop_floating_ui_item()
			inventory_ui.hide()
			hotbar.show()
		elif Input.is_action_just_pressed("drop_all"):
			var touching_mouse_index := inventory_ui.get_touching_mouse_index()
			if touching_mouse_index != -1:
				self_brain.emit_drop_all_index(touching_mouse_index)
		elif Input.is_action_just_pressed("drop"):
				var touching_mouse_index := inventory_ui.get_touching_mouse_index()
				if touching_mouse_index != -1:
					self_brain.emit_drop_index(touching_mouse_index)
	else:
		if Input.is_action_just_pressed("pause"):
			set_pause(!get_tree().paused)
		elif Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = true
			self_brain.set_movement_enabled(false)
			
			## We shouldn't need this if we are updating as often as we should.
			#inventory_ui.update(player_self.get_inventory())
			
			inventory_ui.show()
			hotbar.hide()
			return

func set_pause(pause: bool) -> void:
	get_tree().paused = pause
	pause_screen.visible = get_tree().paused

func resume() -> void:
	set_pause(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_player_inventory_updated(inventory : Array[Item], floating_item : Item) -> void:
	inventory_label.text = "Inventory: %s" % str(inventory)
	hotbar.update_hotbar(inventory.slice(0,5))
	inventory_ui.update(inventory, floating_item)

func on_health_updated(health : float) -> void:
	health_label.text = "Health: %s" % str(health)

func on_selected_index_updated(index : int) -> void:
	hotbar.set_selected(index)

func on_item_collected(item : Item) -> void:
	print("Collected %s" % str(item))

func _drop_floating_ui_item() -> void:
	self_brain.emit_drop_floating()

func _on_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_drop_floating_ui_item()
			MOUSE_BUTTON_RIGHT:
				_drop_floating_ui_item()
