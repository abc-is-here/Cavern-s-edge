extends PlayerState

var ledgeGrabFinalPosition = Vector2.ZERO

func EnterState():
	Name = "LedgeClimb"
	if (Player.RCLedgeLeftLower.is_colliding()):
		Player.ledgeDirection = Vector2.LEFT
	elif (Player.RCLedgeRightLower.is_colliding()):
		Player.ledgeDirection = Vector2.RIGHT
	
	ledgeGrabFinalPosition = Vector2(10 * Player.ledgeDirection.x, -14 + Player.AdditionalLedgeClimbNudge)


func ExitState():
	pass


func Update(delta: float):
	if (Player.movingPlatformCornerGrabPosition != Vector2.ZERO):
		Player.global_position = (Player.movingPlatform.GetPosition() + Player.movingPlatformCornerGrabPosition)
	
	HandleClimbUp()
	HandleAnimations()

func HandleClimbUp():
	Player.Animator.play("LedgeClimb")


func HandleAnimations():
	Player.Sprite.flip_h = (Player.ledgeDirection.x < 0)


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "LedgeClimb"):
		Player.global_position += ledgeGrabFinalPosition
		Player.ChangeState(States.Idle)
		Player.jumps = 0
		Player.dashes = 0
