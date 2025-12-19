class_name PlayerEntity extends PersonEntity

signal player_inventory_updated(inventory : Array[Item], floating_item : Item)

var _floating_item : Item = null
var in_ui : bool = false

func _connect_to_brain() -> void:
	super._connect_to_brain()
	if brain is SelfBrain:
		brain.drop_floating.connect(_drop_floating)
		brain.in_ui.connect(_set_in_ui)
		brain.inventory_left_clicked.connect(_on_inventory_left_click)
		brain.inventory_left_clicked.connect(_on_inventory_right_click)

func set_movement_enabled(enabled : bool) -> void:
	if brain is SelfBrain:
		brain.set_movement_enabled(enabled)

func _emit_inventory_updated() -> void:
	super._emit_inventory_updated()
	player_inventory_updated.emit(_inventory,_floating_item)

func _set_in_ui(value : bool) -> void:
	in_ui = value

func _drop_floating() -> void:
	
	if !(in_ui and _floating_item):
		return
	
	drop(_floating_item)
	_floating_item = null

func _on_inventory_left_click(index : int) -> void:
	
	if !in_ui:
		return
	
	var clicked_item : Item = _inventory[index]
	if _floating_item:
		if clicked_item:
			# TODO: Only swap if items are different. Otherwise, try to combine them!
			var temp = _floating_item.duplicate()
			_floating_item = clicked_item
			_inventory[index] = temp
			_emit_inventory_updated()
		else:
			_inventory[index] = _floating_item
			_floating_item = null
			_emit_inventory_updated()
	else:
		if clicked_item:
			_floating_item = clicked_item
			_inventory[index] = null
			_emit_inventory_updated()
		else:
			pass

	
func _on_inventory_right_click(index : int) -> void:
	
	if !in_ui:
		return
	
	var clicked_item : Item = _inventory[index]
	if _floating_item:
		if clicked_item:
			# If they are the same, add one to the stack!
			if _floating_item.item_name == clicked_item.item_name:
				pass
			#floating_slot.update(clicked_item)
			#clicked_slot.update(floating_item)
		else:
			# Leave one behind
			var grabbed_item = null if _floating_item.item_quantity <= 1 else Item.new(_floating_item.item_name,_floating_item.item_quantity - 1)
			var left_behind_item = Item.new(_floating_item.item_name,1) 
			_floating_item = grabbed_item
			_inventory[index] = left_behind_item
			_emit_inventory_updated()
	else:
		if clicked_item:
			# Grab half
			var half = clicked_item.item_quantity / 2.0
			var upper = int(ceil(half))
			var lower = int(floor(half))
			var grabbed_item = Item.new(clicked_item.item_name,upper)
			var left_behind_item = Item.new(clicked_item.item_name,lower) if lower > 0 else null
			_floating_item = grabbed_item
			_inventory[index] = left_behind_item
			_emit_inventory_updated()
		else:
			# Do nothing
			pass
