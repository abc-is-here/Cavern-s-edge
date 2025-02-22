class_name jump_peak extends PlayerState

func EnterState():
	Name = "JumpPeak"


func ExitState():
	pass


func Update(delta: float):
	Player.HorizontalMovement()
	Player.HandleWallJump()
	Player.ChangeState(States.Fall)
	HandleAnimations()


func HandleAnimations():
	Player.Animator.play("Jump")
	Player.HandleFlipH()
