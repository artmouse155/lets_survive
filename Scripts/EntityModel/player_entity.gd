class_name PlayerEntity extends PersonEntity

func set_movement_enabled(enabled : bool) -> void:
	if brain is SelfBrain:
		brain.set_movement_enabled(enabled)
