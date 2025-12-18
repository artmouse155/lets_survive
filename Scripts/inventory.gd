class_name Inventory extends PanelContainer

const UI_SLOT_PACKED = preload("uid://crl2y8wmcwmkk")
var ui_slot_nodes : Array[UISlot] = []
var clicked_slot : UISlot = null

signal inventory_slot_set(index: int, item: Item)

@export var floating_slot : Slot
@export var ui_slot_container : Control

# Called when the node enters the scene tree for the first time.
func update(inventory : Array[Item]) -> void:
	ui_slot_nodes = _setup_slot_container(inventory)

func _setup_slot_container(inventory : Array[Item]) -> Array[UISlot]:
	var output : Array[UISlot]
	for child in ui_slot_container.get_children():
		if is_instance_of(child,UISlot):
			child.queue_free()
	for i in range(len(inventory)):
		var slot : UISlot = UI_SLOT_PACKED.instantiate()
		slot.update(inventory[i])
		slot.left_click.connect(_on_left_clicked.bind(slot,i))
		slot.right_click.connect(_on_right_clicked.bind(slot,i))
		ui_slot_container.add_child(slot)
		output.append(slot)
	return output

func _process(_delta: float) -> void:
	floating_slot.global_position = get_global_mouse_position()

func _on_left_clicked(ui_slot : UISlot, inventory_index : int):
	clicked_slot = ui_slot
	var clicked_item : Item = clicked_slot.get_item() if clicked_slot else null
	var floating_item : Item = floating_slot.get_item()
	if floating_item:
		if clicked_item:
			# TODO: Only swap if items are different. Otherwise, try to combine them!
			floating_slot.update(clicked_item)
			clicked_slot.update(floating_item)
			inventory_slot_set.emit(inventory_index,floating_item)
		else:
			floating_slot.update(null)
			clicked_slot.update(floating_item)
			inventory_slot_set.emit(inventory_index,floating_item)
	else:
		if clicked_item:
			floating_slot.update(clicked_item)
			clicked_slot.update(null)
			inventory_slot_set.emit(inventory_index,null)
		else:
			pass

func _on_right_clicked(ui_slot : UISlot, inventory_index : int):
	clicked_slot = ui_slot
	var clicked_item : Item = clicked_slot.get_item() if clicked_slot else null
	var floating_item : Item = floating_slot.get_item()
	if floating_item:
		if clicked_item:
			# If they are the same, add one to the stack!
			if floating_item.item_name == clicked_item.item_name:
				pass
			#floating_slot.update(clicked_item)
			#clicked_slot.update(floating_item)
		else:
			# Leave one behind
			var grabbed_item = null if floating_item.item_quantity <= 1 else Item.new(floating_item.item_name,floating_item.item_quantity - 1)
			var left_behind_item = Item.new(floating_item.item_name,1) 
			floating_slot.update(grabbed_item)
			clicked_slot.update(left_behind_item)
			inventory_slot_set.emit(inventory_index,left_behind_item)
	else:
		if clicked_item:
			# Grab half
			var half = clicked_item.item_quantity / 2.0
			var upper = int(ceil(half))
			var lower = int(floor(half))
			var grabbed_item = Item.new(clicked_item.item_name,upper)
			var left_behind_item = Item.new(clicked_item.item_name,lower) if lower > 0 else null
			floating_slot.update(grabbed_item)
			clicked_slot.update(left_behind_item)
			inventory_slot_set.emit(inventory_index,left_behind_item)
		else:
			# Do nothing
			pass

func pop_floating_item() -> Item:
	var item := floating_slot.get_item()
	floating_slot.update(null)
	return item

func pop_all_touching_mouse() -> Item:
	for i in range(len(ui_slot_nodes)):
		var slot := ui_slot_nodes[i]
		if slot.is_under_mouse():
			var item := slot.get_item()
			slot.update(null)
			inventory_slot_set.emit(i,null)
			return item
	return null
