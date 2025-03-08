extends Area2D

@export var gravity_multiplier: float = 0.3
@export var velocity_multiplier: float = 0.5

var player: PlayerController = null

func _on_body_entered(body):
	if body is PlayerController:
		Global.is_in_water = true
		player = body
		apply_water_effects()

func _on_body_exited(body):
	if body is PlayerController:
		Global.is_in_water = false
		reset_player_values()

func apply_water_effects():
	if player:
		player.WallJumpVelocity *= gravity_multiplier
		player.WallSlideSpeed *= gravity_multiplier
		player.WallJumpHSpeed *= gravity_multiplier
		player.GravityJump *= gravity_multiplier
		player.GravityFall *= gravity_multiplier
		player.moveSpeed *= velocity_multiplier
		player.jumpSpeed *= velocity_multiplier

func reset_player_values():
	if player:
		player.WallJumpVelocity = -190
		player.WallSlideSpeed = 40
		player.WallJumpHSpeed = 120
		player.GravityJump = 600
		player.GravityFall = 900
		player.moveSpeed = player.RunSpeed
		player.jumpSpeed = player.JumpVelocity
