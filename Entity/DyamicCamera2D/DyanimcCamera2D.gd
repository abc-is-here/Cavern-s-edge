@icon("res://Assets/Camera2D Area Icon.svg")
class_name DynamicCamera2D extends Node2D

@onready var Camera: Camera2D = $Camera2D
@onready var Area: Area2D = $Area2D
@onready var Collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var DeathRect: ColorRect = $RedFlash/ColorRect
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var rock = get_tree().get_first_node_in_group("rock")

var currentZone = null
var cameraZones = []

func _ready() -> void:
	DeathRect.visible = false
	Global.connect("shake_camera", Callable(self, "shake_camera"))
	Global.connect("DashFallBack", Callable(self, "fallback_on_dash"))
	Global.connect("RockFall", Callable(self, "shake_on_rock_fall"))

func _process(delta: float) -> void:
	var _areas = Area.get_overlapping_areas()
	if (cameraZones.size() == 0):
		Camera.limit_bottom = 10_000
		Camera.limit_top = -10_000
		Camera.limit_right = 10_000
		Camera.limit_left = -10_000
	else:
		currentZone = cameraZones[cameraZones.size() - 1]
		if (currentZone is CameraZone2D):
			Camera.limit_bottom = currentZone.Zone.global_position.y + currentZone.Zone.shape.extents.y
			Camera.limit_top = currentZone.Zone.global_position.y - currentZone.Zone.shape.extents.y
			Camera.limit_right = currentZone.Zone.global_position.x + currentZone.Zone.shape.extents.x
			Camera.limit_left = currentZone.Zone.global_position.x - currentZone.Zone.shape.extents.x
		else:
			Camera.limit_bottom = 10_000
			Camera.limit_top = -10_000
			Camera.limit_right = 10_000
			Camera.limit_left = -10_000


func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area is CameraZone2D):
		cameraZones.append(area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if (area is CameraZone2D):
		cameraZones.erase(area)

func shake_camera():
	DeathRect.visible = true
	await get_tree().create_timer(0.1).timeout
	DeathRect.visible = false
	var tween = create_tween()
	tween.tween_property(Camera, "offset", Vector2(10, 10), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Camera, "offset", Vector2(-10, -10), 0.05)
	tween.tween_property(Camera, "offset", Vector2(0, 0), 0.05)

func fallback_on_dash():
	var tween = create_tween()
	var fallback_offset = Vector2(10, 0)
	tween.tween_property(Camera, "offset", fallback_offset, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_property(Camera, "offset", Vector2(0, 0), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func shake_on_rock_fall():
	var tween = create_tween()
	tween.tween_property(Camera, "offset", Vector2(5, 5), 0.05).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(Camera, "offset", Vector2(-5, -5), 0.05)
	tween.tween_property(Camera, "offset", Vector2(0, 0), 0.05)
