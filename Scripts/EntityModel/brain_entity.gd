@abstract
class_name BrainEntity extends Entity

@export var max_health : float = 100.0
@export var health : float = 100.0

## Area of this BrainEntity's attack.
@export var hitBox : Area2D

## Area of which points count for other attacks hitting this BrainEntity.
@export var hurtBox : Area2D
