extends PlayerState

const ledgeReleaseXNudge = 1
const ledgeReleaseYNudge = 5

var ledgeGrabSnapPosition = Vector2.ZERO

func EnterState():
	Name = "LedgeGrab"
	
	if (Player.RCLedgeLeftLower.is_colliding()):
		Player.ledgeDirection = Vector2.LEFT
	elif (Player.RCLedgeRightLower.is_colliding()):
		Player.ledgeDirection = Vector2.RIGHT

	ledgeGrabSnapPosition = Vector2(Player.cornerGrabPosition.x + (Player.ledgeDirection.x * -1), Player.cornerGrabPosition.y + 6)
	var adjustment: Vector2 = Vector2(Player.ledgeDirection.x * -1, 6)
	Player.movingPlatformCornerGrabPosition += adjustment


func ExitState():
	Player.Animator.speed_scale = 1
	Player.jumps = Player.MaxJumps
	Player.dashes = Player.MaxDashes


func Update(delta: float):
	Player.velocity = Vector2.ZERO
	if (Player.movingPlatformCornerGrabPosition != Vector2.ZERO):
		Player.global_position = (Player.movingPlatform.GetPosition() + Player.movingPlatformCornerGrabPosition)
	else:
		Player.global_position = ledgeGrabSnapPosition
	
	Player.climbStamina -= Player.GrabStaminaCost
	HandleJumpUp()
	HandleClimbUp()
	HandleLedgeRelease()
	HandleAnimations()


func HandleLedgeRelease():
	if (Player.keyDown or (Player.climbStamina <= 0)
	or ((Player.resettingPlatform != null) and (Player.resettingPlatform.currentState == Player.resettingPlatform.PlatformStates.Broken))):
		Player.global_position += Vector2(ledgeReleaseXNudge * Player.ledgeDirection.x * -1,
			ledgeReleaseYNudge)
		Player.ChangeState(States.Fall)

func HandleJumpUp():
	if (Player.keyJumpPressed):
		Player.global_position += Vector2(ledgeReleaseXNudge * Player.ledgeDirection.x * -2, -ledgeReleaseYNudge)
		Player.ChangeState(States.Jump)


func HandleClimbUp():
	if (Player.keyUpPressed):
		Player.ChangeState(States.LedgeClimb)


func HandleAnimations():
	Player.Animator.play("LedgeGrab")
	Player.Sprite.flip_h = (Player.ledgeDirection.x < 0)
