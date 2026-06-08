class_name ZoomableCamera
extends Camera2D

const ZOOM_INCREMENT: float = 0.2
var zoom_factor: int = 0
var target_zoom := Vector2.ONE
const ZOOM_FACTOR_MIN := -5
const ZOOM_FACTOR_MAX := 10
const SMOOTH_ZOOM_AMT := 0.2

func _init() -> void:
	position_smoothing_speed = 8.0
	position_smoothing_enabled = true

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("zoom_in"):
		zoom_factor += 1
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_factor -= 1
	zoom_factor = clampi(zoom_factor, ZOOM_FACTOR_MIN, ZOOM_FACTOR_MAX)
	var z_final := pow(1 + ZOOM_INCREMENT,zoom_factor)
	target_zoom = Vector2(z_final, z_final)
	zoom = lerp(zoom, target_zoom, SMOOTH_ZOOM_AMT)
