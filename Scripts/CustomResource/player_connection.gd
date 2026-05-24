class_name PlayerConnection extends Resource

@export var player_name : String = "unset player name"
@export var state : States = States.UNREGISTERED

enum States {UNREGISTERED, REGISTERED, INVALID}
