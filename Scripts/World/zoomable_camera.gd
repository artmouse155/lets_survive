class_name ZoomableCamera
extends Camera2D

const ZOOM_INCREMENT: float = 0.1
var zoom_factor: int = 0
const ZOOM_FACTOR_MIN := -10
const ZOOM_FACTOR_MAX := 20

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_factor += 1
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_factor -= 1
	zoom_factor = clampi(zoom_factor, ZOOM_FACTOR_MIN, ZOOM_FACTOR_MAX)
	var z_final := pow(1 + ZOOM_INCREMENT,zoom_factor)
	zoom = Vector2(z_final, z_final)
