extends PlayerState

var climbDirection = Vector2.ZERO

func EnterState():
	Name = "WallClimb"


func ExitState():
	pass


func Draw():
	pass


func Update(delta):
	Player.GetCanWallClimb()
	Player.climbStamina -= Player.ClimbStaminaCost
	HandleClimbMovement(delta)
	Player.HandleWallRelease()
	Player.HandleWallJump()
	Player.HandleDash()
	HandleAnimations()
	
	if (Player.movingPlatform):
		Player.global_position = Player.movingPlatform.GetPosition() + Player.movingPlatformOffset


func HandleClimbMovement(delta: float):
	var speed = 0
	
	if (Player.keyClimb):
		if (Player.wallClimbDirection != Vector2.ZERO):
			if (Player.keyUp and (Player.RCUpperLeft.is_colliding() or Player.RCUpperRight.is_colliding())):
				climbDirection = Vector2.UP
				speed = Player.ClimbSpeed
			elif (Player.keyDown and (Player.RCLowerLeft.is_colliding() or Player.RCLowerRight.is_colliding())):
				climbDirection = Vector2.DOWN
				speed = Player.ClimbSpeed
			else:
				Player.ChangeState(States.WallGrab)
	else:
		Player.ChangeState(States.Fall)
	
	if (Player.movingPlatform):
		Player.movingPlatformOffset += Vector2(0, (speed * climbDirection.y) * delta)
	else:
		Player.velocity.y = speed * climbDirection.y


func HandleAnimations():
	if (climbDirection == Vector2.UP):
		Player.Animator.speed_scale = -1
	elif (climbDirection == Vector2.DOWN):
		Player.Animator.speed_scale = 1
	
	Player.Animator.play("WallClimb")
	Player.Sprite.flip_h = (Player.wallClimbDirection == Vector2.LEFT)
