extends Control

@export var health_label : Label
@export var inventory_label : Label

@export var pause_screen : Control
@export var hotbar : Hotbar
@export var inventory_ui : Inventory
@export var player_self : PlayerSelf

var is_in_ingame_ui : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
		
	if is_in_ingame_ui:
		if Input.is_action_just_pressed("pause") or Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = false
			player_self.set_movement_enabled(true)
			_drop_floating_ui_item()
			inventory_ui.hide()
			hotbar.show()
		elif Input.is_action_just_pressed("drop_all_selected_item"):
			_drop_item(inventory_ui.pop_all_touching_mouse())
	else:
		if Input.is_action_just_pressed("pause"):
			set_pause(!get_tree().paused)
		elif Input.is_action_just_pressed("open_inventory"):
			is_in_ingame_ui = true
			player_self.set_movement_enabled(false)
			inventory_ui.update(player_self.get_inventory())
			inventory_ui.show()
			hotbar.hide()
			return

func set_pause(pause: bool) -> void:
	get_tree().paused = pause
	pause_screen.visible = get_tree().paused

# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_inventory_updated(inventory : Array[Item]) -> void:
	inventory_label.text = "Inventory: %s" % str(inventory)
	hotbar.update_hotbar(inventory.slice(0,5))
	inventory_ui.update(inventory)

func on_health_updated(health : float) -> void:
	health_label.text = "Health: %s" % str(health)

func on_selected_index_updated(index : int) -> void:
	hotbar.set_selected(index)

func on_item_collected(item : Item) -> void:
	print("Collected %s" % str(item))

func on_inventory_item_set(index : int, item : Item) -> void:
	player_self.set_inventory_at_index(index,item)

func _drop_floating_ui_item() -> void:
	_drop_item(inventory_ui.pop_floating_item())

func _drop_item(item : Item) -> void:
	if item:
		player_self.drop(item)

func _on_gui_input(event : InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				_drop_floating_ui_item()
			MOUSE_BUTTON_RIGHT:
				_drop_floating_ui_item()
