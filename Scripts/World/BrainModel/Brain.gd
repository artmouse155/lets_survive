@icon("uid://crgtq8dkggumf")
@abstract
class_name Brain extends Resource

func _emit(s : Signal, ...args: Array) -> void:
	s.emit.callv(args)

@abstract
func physics_process(_delta: float, viewport: Viewport) -> void
