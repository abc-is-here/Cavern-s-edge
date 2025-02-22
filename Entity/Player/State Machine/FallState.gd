extends PlayerState

func EnterState():
	Name = "Fall"
	Player.movingPlatform = null

func ExitState():
	Player.SetSquish(1.10, 0.9)
	Player.movingPlatformSpeedBonus = Vector2.ZERO


func Update(delta: float):
	Player.GetCanWallClimb()
	Player.HandleGravity(delta, Player.GravityFall)
	Player.HorizontalMovement(Player.AirAcceleration, Player.AirDeceleration)
	Player.HandleLanding()
	Player.HandleJump()
	Player.HandleJumpBuffer()
	Player.HandleWallJump()
	Player.HandleWallSlide()
	Player.HandleWallGrab()
	Player.HandleDash()
	Player.HandleLedgeGrab()
	HandleAnimations()


func HandleAnimations():
	Player.Animator.play("Fall")
	Player.HandleFlipH()
