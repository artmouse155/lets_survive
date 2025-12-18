class_name HumanSprite extends EntitySprite

enum ANIMATIONS {IDLE, PUNCH, SWING}

@export var anim_state : ANIMATIONS = ANIMATIONS.IDLE
@export var _tool_state : Item.TOOL_TYPE = Item.TOOL_TYPE.FISTS
@export var melee_radius: MeleeRadius

@export var _tool_sprite : Sprite2D

func _ready() -> void:
	super._ready()
	_update_tool_state()

func _get_inventory_size() -> int:
	return 5

func attack() -> void:
	match _tool_state:
		Item.TOOL_TYPE.FISTS:
			anim_state = ANIMATIONS.PUNCH
		Item.TOOL_TYPE.SWORD:
			anim_state = ANIMATIONS.SWING

func go_idle() -> void:
	anim_state = ANIMATIONS.IDLE

func select(index : int) -> void:
	super.select(index)
	var selected_item := get_selected_item()
	print("Item %s selected: %s" % [str(index), str(selected_item)])
	_update_tool_state()
	
func _update_tool_state() -> void:
	var selected_item := get_selected_item()
	if selected_item and selected_item.is_tool():
		_tool_state = selected_item.get_tool_type()
		_tool_sprite.show()
	else:
		_tool_state = Item.TOOL_TYPE.FISTS
		_tool_sprite.hide()

func _eval_attack():
	for target in melee_radius.get_overlapping_bodies():
		if is_instance_of(target,Breakable):
			#TODO: Distribute damage across targets?
			target.take_damage(10, global_position)

func pickup_item(item : Item) -> Item:
	var leftovers := super.pickup_item(item)
	_update_tool_state()
	return leftovers

func drop_selected_item() -> void:
	super.drop_selected_item()
	_update_tool_state()

func drop_all_selected_item() -> void:
	super.drop_all_selected_item()
	_update_tool_state()

func set_inventory_at_index(index: int, item: Item) -> void:
	super.set_inventory_at_index(index,item)
	_update_tool_state()
