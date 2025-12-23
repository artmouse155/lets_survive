@icon("uid://crgtq8dkggumf")
@abstract
class_name Brain extends Node

func _emit(s : Signal, ...args) -> void:
	s.emit.callv(args)
