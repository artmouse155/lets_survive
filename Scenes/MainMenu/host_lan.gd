extends Menu

@export var port_node: SpinBox

signal unpause
signal host(port: String)

func start() -> void:
	pass

#func validate_port_input(new_value: float) -> void:
	#pass


func _on_start_pressed() -> void:
	unpause.emit()
	host.emit(str(port_node.value))
