extends Node2D

@export var speed: int = 50


func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += speed * delta
