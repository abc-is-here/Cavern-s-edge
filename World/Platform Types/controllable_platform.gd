extends CharacterBody2D

@export var speed: float = 100.0
@export var max_reset_time: float = 10.0
var player_on_platform: bool = false
var start_position: Vector2
var last_direction: int = 0

@onready var reset_timer: Timer = $ResetTimer

func _ready():
	start_position = global_position
	set_process(true)
	reset_timer.wait_time = max_reset_time
	reset_timer.one_shot = true
	$lever.frame = 1

func _physics_process(delta):
	var move_direction = last_direction

	velocity.y = 0

	if player_on_platform:
		if Input.is_action_pressed("platform_move_left"):
			move_direction = -1
			last_direction = move_direction
			$lever.frame = 0
		elif Input.is_action_pressed("platform_move_right"):
			move_direction = 1
			last_direction = move_direction
			$lever.frame = 2
		elif Input.is_action_pressed("platform_stop"):
			move_direction = 0
			last_direction = 0
			$lever.frame = 1
	
	velocity.x = move_direction * speed
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):  
		player_on_platform = true
		body.set_floor_stop_on_slope_enabled(false)
		reset_timer.stop()

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		player_on_platform = false
		body.set_floor_stop_on_slope_enabled(true)

		reset_timer.start()

func _on_reset_timer_timeout() -> void:
	if not player_on_platform:
		global_position = start_position
		velocity = Vector2.ZERO
		last_direction = 0
