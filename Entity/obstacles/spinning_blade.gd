extends Node2D

@export var speed: int = 50

func _ready() -> void:
	$AnimationPlayer.play("spin")

func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += speed * delta
