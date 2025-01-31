extends Control

@onready var animation: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation.play("distort")


func _process(delta: float) -> void:
	await animation.animation_finished
	animation.stop()
	queue_free()
