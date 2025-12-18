class_name WorldItem extends Area2D

#const EXPLODE_COOLDOWN
const PACKED : PackedScene = preload("uid://q7wfdi5cus2m")
const INIT_DIST : float = 10
const INT_VEL_DURATION : float = 0.25

@export var _item : Item = null
@export var sprite : Sprite2D

var fly_tween : Tween

var _has_cooldown : bool = false
var cooldown_tween : Tween

func _ready():
	#if !has_cooldown():
		#apply_cooldown(0.0)
	fly_tween = create_tween()
	fly_tween.tween_property(self,"position",position + INIT_DIST * Vector2.from_angle(randf_range(0.0, TAU)),INT_VEL_DURATION).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

func _set_item(item : Item):
	_item = item
	sprite.texture = item.get_texture()

func get_item():
	return _item

func apply_cooldown(cooldown : float):
	if cooldown_tween:
		cooldown_tween.kill()
	_set_has_cooldown(true)
	cooldown_tween = create_tween()
	cooldown_tween.tween_interval(cooldown)
	cooldown_tween.tween_callback(_set_has_cooldown.bind(false))

func has_cooldown() -> bool:
	return _has_cooldown

func _set_has_cooldown(value : bool):
	_has_cooldown = value

static func from(item : Item) -> WorldItem:
	var world_item : WorldItem = PACKED.instantiate()
	world_item._set_item(item)
	return world_item

static func from_separate(item : Item) -> Array[WorldItem]:
	var output : Array[WorldItem]
	for i in range(item.item_quantity):
		var world_item : WorldItem = PACKED.instantiate()
		world_item._set_item(item)
		output.append(world_item)
	return output
