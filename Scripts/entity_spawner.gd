class_name EntitySpawner extends Node2D

const PLAYER_PACKED : PackedScene = preload("uid://bfwu7kuh082tc")
@export var self_brain : SelfBrain

func on_world_item_dropped(sender : Node2D, item : Item, cooldown : float = 0) -> void:
	var world_item : WorldItem = WorldItem.from(item)
	world_item.position = sender.global_position
	world_item.apply_cooldown(cooldown)
	add_child(world_item)

func spawn_player(player_save : PlayerSave, is_self : bool) -> void:
	var player : PlayerEntity = PLAYER_PACKED.instantiate()
	if is_self:
		player.add_child(Camera2D.new())
		player.brain = self_brain
	add_child(player)
