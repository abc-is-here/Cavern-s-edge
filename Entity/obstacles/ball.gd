class_name Stone
extends CharacterBody2D

@export var gravity: float = 500
@export var bounce_strength: float = -30
@export var speed: float = 100
@export var direction: int = 1
@export var friction: float = 0.9
@onready var right_rc: RayCast2D = $RCs/righRc
@onready var left_rc: RayCast2D = $RCs/LeftRC
@onready var r_cs: Node2D = $RCs

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		velocity.y = bounce_strength
		rotation_degrees += 2000 * delta
		r_cs.rotation_degrees-=2000*delta

		# Check for walls using raycasts
		if left_rc.is_colliding() and direction == -1:
			direction = 1  # Change direction to right
		elif right_rc.is_colliding() and direction == 1:
			direction = -1  # Change direction to left

		velocity.x = direction * speed

	move_and_slide()
