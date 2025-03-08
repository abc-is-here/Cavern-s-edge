extends Area2D

var speedUp = 2
@export var dir_x: int
@export var dir_y: int

func _on_body_entered(body: Node2D) -> void:
	if (body is PlayerController):
		if dir_x == 1:
			body.velocity.x = -body.JumpVelocity * speedUp
		if dir_x == -1:
			body.velocity.x = body.JumpVelocity * speedUp
		if dir_y == 1:
			body.velocity.y = body.JumpVelocity * speedUp
		if dir_y == -1:
			body.velocity.y = -body.JumpVelocity * speedUp

			
