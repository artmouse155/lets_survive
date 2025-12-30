class_name Breakable extends StaticBody2D

const SHAKE_AMT : float = 2
const SHAKE_DURATION : float = 0.05

@export var sprite: Node2D

@export var base_health: float = 50.0
@export var toughness: float = 10.0
var health : float = 0.0

signal world_item_dropped(sender : Node2D, item : Item)

var shake_tween : Tween

func _ready() -> void:
	health = base_health

func take_damage(damage : float, attack_origin : Vector2) -> void:
	health -= damage
	if (health <= 0):
		destroy()
	else:
		if (shake_tween):
			shake_tween.kill()
		shake_tween = create_tween()
		shake_tween.tween_property(sprite,"position",(position - attack_origin).normalized() * SHAKE_AMT,SHAKE_DURATION)
		shake_tween.tween_property(sprite,"position",Vector2.ZERO,SHAKE_DURATION)


func destroy() -> void:
	world_item_dropped.emit(self,Item.new(Item.WOOD,5))
	queue_free()
