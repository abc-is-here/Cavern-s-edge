extends Control

@onready var Animator = $Animator

func _ready() -> void:
	Animator.play("Distort")


func _process(delta: float) -> void:
	await Animator.animation_finished
	Animator.stop()
	queue_free()
