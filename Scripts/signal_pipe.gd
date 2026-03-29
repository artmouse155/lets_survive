class_name SignalPipe extends Object

static func pipe(source : Signal, output : Signal) -> void:
	source.connect(func(...args: Array)-> void: output.emit.callv(args))
