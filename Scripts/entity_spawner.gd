class_name EntitySpawner extends Node2D

func on_world_item_dropped(sender : Node2D, item : Item, cooldown : float = 0) -> void:
	var world_item : WorldItem = WorldItem.from(item)
	world_item.position = sender.global_position
	world_item.apply_cooldown(cooldown)
	add_child(world_item)
