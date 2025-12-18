class_name PlayerSelf extends CharacterBody2D

@export var sprite : PlayerEntity
# Called when the node enters the scene tree for the first time.
@export var speed = 125

const HOTBAR_SIZE : int = 5

signal health_updated(health : float)
signal inventory_updated(inventory : Array[Item])
signal selected_index_updated(index : int)
signal item_collected(item : Item)

var is_movement_disabled : bool = false

func _ready():
	inventory_updated.emit(get_inventory())
	selected_index_updated.emit(0)

func _get_input():
	
	if is_movement_disabled:
		return
	
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	if Input.is_action_pressed("attack"):
		sprite.attack()
	else:
		sprite.go_idle()
	
	if Input.is_action_just_pressed("select_0"):
		_select(0)
	elif Input.is_action_just_pressed("select_1"):
		_select(1)
	if Input.is_action_just_pressed("select_next"):
		if sprite.get_selected_index() >= (HOTBAR_SIZE - 1):
			_select(0)
		else:
			_select(sprite.get_selected_index() + 1)
	elif Input.is_action_just_pressed("select_prev"):
		if sprite.get_selected_index() <= (0):
			_select(HOTBAR_SIZE - 1)
		else:
			_select(sprite.get_selected_index() - 1)
	if Input.is_action_just_pressed("drop_all_selected_item"):
		sprite.drop_all_selected_item()
		inventory_updated.emit(get_inventory())
	elif Input.is_action_just_pressed("drop_selected_item"):
		sprite.drop_selected_item()
		inventory_updated.emit(get_inventory())

func _get_look_direction() -> void:	
	var look_direction = get_local_mouse_position().angle()
	sprite.rotation = look_direction

func _physics_process(_delta):
	_get_input()
	_get_look_direction()
	move_and_slide()

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if is_instance_of(area, WorldItem) and !area.has_cooldown():
		var item : Item = area.get_item()
		print("Trying to collect %s" % str(item))
		var count_before = item.item_quantity if item else 0
		var leftovers : Item = sprite.pickup_item(area.get_item())
		var count_after = leftovers.item_quantity if leftovers else 0
		var count = count_before - count_after
		if (item and count > 0):
			inventory_updated.emit(get_inventory())
			item_collected.emit(Item.new(item.item_name,count))
		if !leftovers:
			area.queue_free()

func get_inventory() -> Array[Item]:
	return sprite.get_inventory()

func _select(index : int) -> void:
	sprite.select(index)
	selected_index_updated.emit(index)

func set_movement_enabled(enabled : bool) -> void:
	is_movement_disabled = !enabled
	if is_movement_disabled:
		velocity = Vector2.ZERO
		sprite.go_idle()

func set_inventory_at_index(index: int, item: Item) -> void:
	sprite.set_inventory_at_index(index,item)
	inventory_updated.emit(get_inventory())

func drop(item: Item) -> void:
	sprite.drop(item)

func take_damage(damage : float):
	sprite.health -= damage
	health_updated.emit(sprite.health)
