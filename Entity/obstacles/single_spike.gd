extends Node2D

@export var anim_delay: float = 0.1

func _ready() -> void:
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = anim_delay
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout() -> void:
	$DeadZone/AnimationPlayer.play("spikeUp")
