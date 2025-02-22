@icon("res://Assets/Camera2D Area Icon.svg")
class_name DynamicCamera2D extends Node2D

@onready var Camera: Camera2D = $Camera2D
@onready var Area: Area2D = $Area2D
@onready var Collider: CollisionShape2D = $Area2D/CollisionShape2D

var currentZone = null

func _process(delta: float) -> void:
	var _areas = Area.get_overlapping_areas()
	if (_areas.size() == 0):
		Camera.limit_bottom = 10_000
		Camera.limit_top = -10_000
		Camera.limit_right = 10_000
		Camera.limit_left = -10_000
	else:
		currentZone = _areas[_areas.size() - 1]
		Camera.limit_bottom = currentZone.Zone.global_position.y + currentZone.Zone.shape.extents.y
		Camera.limit_top = currentZone.Zone.global_position.y - currentZone.Zone.shape.extents.y
		Camera.limit_right = currentZone.Zone.global_position.x + currentZone.Zone.shape.extents.x
		Camera.limit_left = currentZone.Zone.global_position.x - currentZone.Zone.shape.extents.x

func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Area entered: ", area)

func _on_area_2d_area_exited(area: Area2D) -> void:
	print("Area exited: ", area)
