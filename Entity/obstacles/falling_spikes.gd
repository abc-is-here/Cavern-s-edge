extends Node2D

@export var speed = 300.0
var cur_speed = 0.0
var start_position: Vector2

func _ready():
	start_position = position

func _physics_process(delta: float) -> void:
	position.y += cur_speed * delta
	if $RayCast2D.is_colliding():
		reset_spike()

func _on_arrow_start_fall_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlayerController:
		$AnimationPlayer.play("SpikeShake")
		await get_tree().create_timer(0.3).timeout
		fall()

func fall():
	cur_speed = speed

func reset_spike():
	cur_speed = 0.0
	position = start_position
