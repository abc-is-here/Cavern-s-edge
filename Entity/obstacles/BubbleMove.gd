extends CharacterBody2D

const UPWARD_SPEED = -50.0
const SIDE_SPEED = 150.0
const RESET_TIME = 30.0

var original_position: Vector2
var player_inside: bool = false

@onready var reset_timer = $ResetTimer

func _ready():
	original_position = position
	reset_timer.wait_time = RESET_TIME
	reset_timer.start()

func _physics_process(delta: float) -> void:
	velocity.y = UPWARD_SPEED

	if Global.player_in_bubble:
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * SIDE_SPEED
	else:
		velocity.x = 0

	move_and_slide()


func _on_reset_timer_timeout():
	position = original_position
	Global.player_in_bubble = false
	reset_timer.start()
