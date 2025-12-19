@abstract
class_name BrainEntity extends Entity

signal health_updated(health : float)

@export var max_health : float = 100.0
@export var health : float = 100.0

@export var brain : Brain

## Area of this BrainEntity's attack.
@export var hitBox : Area2D

## Area of which points count for other attacks hitting this BrainEntity.
@export var hurtBox : Area2D = self

@abstract
func _connect_to_brain() -> void

func take_damage(damage : float):
	health -= damage
	health_updated.emit(health)

func _eval_attack():
	for target in hitBox.get_overlapping_bodies():
		if is_instance_of(target,Breakable):
			#TODO: Distribute damage across targets?
			target.take_damage(10, global_position)
