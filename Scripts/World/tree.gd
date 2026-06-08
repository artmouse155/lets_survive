extends Breakable

func _ready() -> void:
	%Sprite.rotation = randf_range(0,2*PI)

func take_damage(damage : float, attack_origin : Vector2) -> void:
	super.take_damage(damage, attack_origin)
	%Audio.pitch_scale = 1.0 + randf_range(-.5, .5)
	%Audio.play()
