class_name InventoryUI extends PanelContainer

const UI_SLOT_PACKED = preload("uid://crl2y8wmcwmkk")
var ui_slot_nodes : Array[UISlot] = []
var clicked_slot : UISlot = null

#signal swap_inv_and_floating(index: int)
#signal transfer_inv_to_floating(index: int, fraction: int)
#signal transfer_floating_to_inv(index: int, fraction: int)

signal left_clicked(index: int)
signal right_clicked(index: int)

@export var floating_slot : Slot
@export var ui_slot_container : Control

# Called when the node enters the scene tree for the first time.
func update(inventory : Array[Item], floating_item : Item) -> void:
	#TODO: Make it so I don't have to make and delete nodes every time
	ui_slot_nodes = _setup_slot_container(inventory)
	floating_slot.update(floating_item)

func _setup_slot_container(inventory : Array[Item]) -> Array[UISlot]:
	var output : Array[UISlot]
	for child in ui_slot_container.get_children():
		if is_instance_of(child,UISlot):
			child.queue_free()
	for i in range(len(inventory)):
		var slot : UISlot = UI_SLOT_PACKED.instantiate()
		slot.update(inventory[i])
		slot.left_click.connect(_on_left_clicked.bind(i))
		slot.right_click.connect(_on_right_clicked.bind(i))
		ui_slot_container.add_child(slot)
		output.append(slot)
	return output

func _process(_delta: float) -> void:
	floating_slot.global_position = get_global_mouse_position()

func _on_left_clicked(index : int):
	left_clicked.emit(index)
	#clicked_slot = ui_slot
	##TODO: Instead of doing this math here, do it on the entity itself so it is consistent?
	#var clicked_item : Item = clicked_slot.get_item() if clicked_slot else null
	#var floating_item : Item = floating_slot.get_item()
	#if floating_item:
		#if clicked_item:
			#swap_inv_and_floating.emit(index)
		#else:
			#transfer_floating_to_inv.emit(index,1)
	#else:
		#if clicked_item:
			#transfer_inv_to_floating.emit(index,1)
		#else:
			#pass

func _on_right_clicked(index : int):
	right_clicked.emit(index)
	#clicked_slot = ui_slot
	#var clicked_item : Item = clicked_slot.get_item() if clicked_slot else null
	#var floating_item : Item = floating_slot.get_item()
	#if floating_item:
		#if clicked_item:
			## If they are the same, add one to the stack!
			#if floating_item.item_name == clicked_item.item_name:
				#pass
			##floating_slot.update(clicked_item)
			##clicked_slot.update(floating_item)
		#else:
			## Leave one behind
			#var grabbed_item = null if floating_item.item_quantity <= 1 else Item.new(floating_item.item_name,floating_item.item_quantity - 1)
			#var left_behind_item = Item.new(floating_item.item_name,1) 
			#floating_slot.update(grabbed_item)
			#clicked_slot.update(left_behind_item)
	#else:
		#if clicked_item:
			## Grab half
			#var half = clicked_item.item_quantity / 2.0
			#var upper = int(ceil(half))
			#var lower = int(floor(half))
			#var grabbed_item = Item.new(clicked_item.item_name,upper)
			#var left_behind_item = Item.new(clicked_item.item_name,lower) if lower > 0 else null
			#floating_slot.update(grabbed_item)
			#clicked_slot.update(left_behind_item)
		#else:
			## Do nothing
			#pass

func get_touching_mouse_index() -> int:
	for i in range(len(ui_slot_nodes)):
		var slot := ui_slot_nodes[i]
		if slot.is_under_mouse():
			return i
	return -1
