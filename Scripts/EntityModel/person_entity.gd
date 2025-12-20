class_name PersonEntity extends BrainEntity

const INVENTORY_SIZE : int = 5
const HOTBAR_SIZE : int = 5

signal inventory_updated(inventory : Array[Item])
signal selected_index_updated(index : int)
signal item_collected(item : Item)

## Inventory. Slot 0 represents currently held item.
@export var speed = 125
@export var _inventory : Array[Item]
var _selected_index : int = 0

enum ANIMATIONS {IDLE, PUNCH, SWING}

@export var anim_state : ANIMATIONS = ANIMATIONS.IDLE
@export var _tool_state : Item.TOOL_TYPE = Item.TOOL_TYPE.FISTS
@export var melee_radius: MeleeRadius
@export var _tool_sprite : Sprite2D

func _ready() -> void:
	_connect_to_brain()
	_inventory.resize(INVENTORY_SIZE)
	_update_tool_state()
	_emit_inventory_updated()
	selected_index_updated.emit(0)

func _connect_to_brain() -> void:
	if brain is PersonBrain:
		
		brain.movement_vector.connect(_on_movement_vector)
		brain.look_target.connect(_on_look_target)
		
		brain.attack.connect(attack)
		brain.go_idle.connect(go_idle)
		
		brain.select.connect(select)
		brain.select_next.connect(select_next)
		brain.select_prev.connect(select_prev)
		
		brain.drop_selected_item.connect(drop_selected_item)
		brain.drop_all_selected_item.connect(drop_all_selected_item)
		
		brain.drop_index.connect(drop_index)
		brain.drop_all_index.connect(drop_all_index)


func _emit_inventory_updated() -> void:
	inventory_updated.emit(_inventory)


func _on_movement_vector(movement_vector : Vector2) -> void:
	velocity = movement_vector * speed

func _on_look_target(look_target : float) -> void:
	rotation = look_target


func attack() -> void:
	match _tool_state:
		Item.TOOL_TYPE.FISTS:
			anim_state = ANIMATIONS.PUNCH
		Item.TOOL_TYPE.SWORD:
			anim_state = ANIMATIONS.SWING

func go_idle() -> void:
	anim_state = ANIMATIONS.IDLE

func _update_tool_state() -> void:
	var selected_item := get_selected_item()
	if selected_item and selected_item.is_tool():
		_tool_state = selected_item.get_tool_type()
		_tool_sprite.show()
	else:
		_tool_state = Item.TOOL_TYPE.FISTS
		_tool_sprite.hide()


func get_inventory():
	return _inventory


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
				item = null
				break
		elif (inv_item.item_name == item.item_name) and (!inv_item.is_full()):
			var possible_accept_amt = inv_item.get_max() - inv_item.item_quantity
			var accept_amt = min(possible_accept_amt,item.item_quantity)
			_inventory[i].add(accept_amt)
			item.subtract(accept_amt)
			if item.is_depleted():
				item = null
				break
	_update_tool_state()
	_emit_inventory_updated()
	return item


func select(index : int) -> void:
	_selected_index = index
	#var selected_item := get_selected_item()
	#print("Item %s selected: %s" % [str(index), str(selected_item)])
	_update_tool_state()
	selected_index_updated.emit(index)


func select_next() -> void:
	if _selected_index >= (HOTBAR_SIZE - 1):
		select(0)
	else:
		select(_selected_index + 1)


func select_prev() -> void:
	if _selected_index <= 0:
		select(HOTBAR_SIZE - 1)
	else:
		select(_selected_index - 1)


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
	_update_tool_state()
	_emit_inventory_updated()


func drop_all_selected_item() -> void:
	drop_all_index(_selected_index)


func drop_all_index(index : int) -> void:
	var item = _inventory[index]
	if item:
		world_item_dropped.emit(self,item, 1.0)
		_inventory[index] = null
	_update_tool_state()
	_emit_inventory_updated()


func set_inventory_at_index(index: int, item: Item) -> void:
	_inventory[index] = item
	_update_tool_state()
	_emit_inventory_updated()


func _on_pickup_area_area_entered(area: Area2D) -> void:
	if is_instance_of(area, WorldItem) and !area.has_cooldown():
		var item : Item = area.get_item()
		print("Trying to collect %s" % str(item))
		var count_before = item.item_quantity if item else 0
		var leftovers : Item = pickup_item(area.get_item())
		var count_after = leftovers.item_quantity if leftovers else 0
		var count = count_before - count_after
		if (item and count > 0):
			_emit_inventory_updated()
			item_collected.emit(Item.new(item.item_name,count))
		if !leftovers:
			area.queue_free()
