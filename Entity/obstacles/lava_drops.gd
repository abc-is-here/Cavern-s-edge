extends Node2D

@export var speed = 100.0
var start_position: Vector2

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	position.y += speed * delta
	if $RayCast2D.is_colliding():
		reset_drop()

func reset_drop():
	position = start_position
