@abstract
class_name Entity extends Node2D

signal world_item_dropped(sender : Node2D, item : Item, cooldown: float)

## Inventory. Slot 0 represents currently held item.
@export var _inventory : Array[Item]
@export var max_health : float
@export var health : float

var _selected_index : int = 0

func _ready() -> void:
	_inventory.resize(_get_inventory_size())

func get_inventory():
	return _inventory

@abstract
func _get_inventory_size() -> int

func pickup_item(item : Item) -> Item:
	if (!item):
		return null
	for i : int in range(len(_inventory)):
		var inv_item : Item = _inventory[i]
		if (!inv_item):
			var possible_accept_amt = item.get_max()
			var accept_amt = min(possible_accept_amt,item.item_quantity)
			_inventory[i] = Item.new(item.item_name,accept_amt)
			item.subtract(accept_amt)
			if item.is_depleted():
				return null
		elif (inv_item.item_name == item.item_name) and (!inv_item.is_full()):
			var possible_accept_amt = inv_item.get_max() - inv_item.item_quantity
			var accept_amt = min(possible_accept_amt,item.item_quantity)
			_inventory[i].add(accept_amt)
			item.subtract(accept_amt)
			if item.is_depleted():
				return null
	return item

func select(index : int) -> void:
	_selected_index = index

func get_selected_item() -> Item:
	return _inventory[_selected_index]

func get_selected_index() -> int:
	return _selected_index

func drop(item: Item) -> void:
	world_item_dropped.emit(self,item, 1.0)

func drop_selected_item() -> void:
	drop_index(_selected_index)

func drop_index(index : int) -> void:
	var item = _inventory[index]
	if item:
		world_item_dropped.emit(self,Item.new(item.item_name,1), 1.0)
		_inventory[index] = null if item.item_quantity <= 1 else Item.new(item.item_name,item.item_quantity - 1)

func drop_all_selected_item() -> void:
	drop_all_index(_selected_index)
	
func drop_all_index(index : int) -> void:
	var item = _inventory[index]
	if item:
		world_item_dropped.emit(self,item, 1.0)
		_inventory[index] = null

func set_inventory_at_index(index: int, item: Item) -> void:
	_inventory[index] = item
