class_name Stone
extends CharacterBody2D

@export var gravity: float = 500
@export var bounce_strength: float = -30
@export var speed: float = 100
@export var direction: int = 1
@export var friction: float = 0.9

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if is_on_floor():
		velocity.y = bounce_strength
		rotation_degrees += 2000 * delta

		velocity.x = direction * speed

	move_and_slide()
