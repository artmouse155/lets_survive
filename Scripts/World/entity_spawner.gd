class_name EntitySpawner extends Node2D

signal player_position_updated(pos: Vector2)

signal self_selected_index_updated(index: int)
signal self_inventory_updated(inventory : Array[Item], floating_item : Item)
signal self_item_collected(item : Item)
signal self_health_updated(health : float)

const PLAYER_PACKED : PackedScene = preload("uid://bfwu7kuh082tc")
@export var self_brain : SelfBrain

func on_world_item_dropped(sender : Node2D, item : Item, cooldown : float = 0) -> void:
	var world_item : WorldItem = WorldItem.from(item)
	world_item.position = sender.global_position
	world_item.apply_cooldown(cooldown)
	add_child(world_item)

func spawn_player(player_save : PlayerSave, is_self : bool) -> void:
	var player : PlayerEntity = PLAYER_PACKED.instantiate()
	player.set_inventory(player_save.get_inventory())
	player.set_color(player_save.get_color())
	player.world_item_dropped.connect(on_world_item_dropped)
	SignalPipe.pipe(player.position_updated,player_position_updated)
	if is_self:
		player.add_child(Camera2D.new())
		player.brain = self_brain
		SignalPipe.pipe(player.selected_index_updated,self_selected_index_updated)
		SignalPipe.pipe(player.player_inventory_updated,self_inventory_updated)
		SignalPipe.pipe(player.health_updated,self_health_updated)
		SignalPipe.pipe(player.item_collected,self_item_collected)
	add_child(player)

func clear() -> void:
	for child in get_children():
		child.queue_free()
