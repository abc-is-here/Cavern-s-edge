extends PlayerState


func EnterState():
	Name = "Run"


func ExitState():
	pass


func Update(delta: float):
	Player.HandleFalling()
	Player.HorizontalMovement()
	Player.HandleJump()
	Player.HandleDash()
	Player.HandleOneWayDropThrough()
	HandleAnimations()
	HandleIdle()


func HandleAnimations():
	Player.Animator.play("Run")
	Player.HandleFlipH()


func HandleIdle():
	if (Player.moveDirectionX == 0):
		Player.ChangeState(States.Idle)
