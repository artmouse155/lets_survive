@tool
class_name MeleeRadius extends Area2D

@export var cPolygon : CollisionPolygon2D

@export var radius : float = 100:
	get:
		return radius
	set(value):
		radius = value
		_adjust_collision_polygon()

@export_range(0,PI/2) var arc_angle : float = PI/2:
	get:
		return arc_angle
	set(value):
		arc_angle = value
		_adjust_collision_polygon()

@export_range(2,10) var precision : int = 4:
	get:
		return precision
	set(value):
		precision = value
		_adjust_collision_polygon()

func _adjust_collision_polygon():
	if (cPolygon):
		var new_polygon : PackedVector2Array = []
		new_polygon.append(Vector2.ZERO)
		for i in range(precision):
			var frac : float = float(i) / (precision - 1)
			var point : Vector2 = (Vector2.ONE * radius).rotated((PI/-4) + (frac * arc_angle) - (arc_angle / 2))
			new_polygon.append(point)
		cPolygon.polygon = new_polygon
