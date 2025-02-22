@icon("res://Assets/Camera2D Area Icon.svg")
class_name CameraZone2D extends Area2D

@export var Zone: CollisionShape2D
@export var ZoneDimensions: Vector2 = Vector2(640, 360)

func _ready() -> void:
	ZoneDimensions = Zone.shape.extents
