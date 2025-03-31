extends CharacterBody2D

var push = false
var dir = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") 

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta 

	if push:
		velocity.x = dir * 1500*delta
	else:
		velocity.x = 0

	move_and_slide()

func _on_left_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dir = 1
		push = true

func _on_left_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		push = false

func _on_right_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		dir = -1
		push = true

func _on_right_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		push = false
