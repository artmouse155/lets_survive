class_name HotbarSlot extends Slot

@export var selected : Control

func set_selected(is_selected : bool) -> void:
	selected.visible = is_selected

#var texture_tween: Tween = null
#func _tween_texture() -> void:
	#if texture_tween:
		#texture_tween.kill()
	#texture_tween = create_tween()
	#texture_tween.tween_property(texture_node, "scale", Vector2(1.5,1.5), 0.2)
	#texture_tween.tween_property(texture_node, "scale", Vector2(1.0,1.0), 0.2)
	#
#func update(item : Item) -> void:
	#var old_count := _item.item_quantity if _item else 0
	#print("OLD ITEM: %s" % (_item.to_string() if _item else "null"))
	#var new_count := item.item_quantity if item else 0
	#super.update(item)
	#print("NEW ITEM: %s" % (_item.to_string() if item else "null"))
	#if new_count > old_count:
		#_tween_texture()
