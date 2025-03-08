extends Node2D

@onready var arrow: Area2D = $arrow
@export var arrow_speed = 200

func _process(delta: float) -> void:
	arrow.translate(Vector2.LEFT*arrow_speed*delta)
	if $arrow/RayCast2D.is_colliding():
		arrow.global_position = $Thrower/Marker2D.global_position
