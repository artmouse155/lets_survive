class_name InventoryUI extends PanelContainer

const UI_SLOT_PACKED = preload("uid://crl2y8wmcwmkk")

@export var floating_slot : Slot
@export var ui_slot_container : Control

var ui_slot_nodes : Array[UISlot] = []
var clicked_slot : UISlot = null

signal left_clicked(index: int)
signal right_clicked(index: int)
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

func _on_right_clicked(index : int):
	right_clicked.emit(index)

func get_touching_mouse_index() -> int:
	for i in range(len(ui_slot_nodes)):
		var slot := ui_slot_nodes[i]
		if slot.is_under_mouse():
			return i
	return -1
