extends PlayerState

var lastWallDirection
var shouoldEnableWallKick

func EnterState():
	Name = "WallJump"
	
	if (Player.movingPlatform):
		if (Player.movingPlatformJumpMomentum.y < 0):
			Player.velocity = Vector2(Player.movingPlatformJumpMomentum.x, Player.WallJumpVelocity)
		else:
			Player.velocity = Vector2(Player.movingPlatformJumpMomentum.x, Player.movingPlatformJumpMomentum.y + Player.WallJumpVelocity)
	else:
		Player.velocity.y = Player.JumpVelocity
	
	Player.movingPlatform = null
	ShouldOnlyJumpButtonWallKick(false)
	lastWallDirection = Player.wallDirection


func ExitState():
	pass


func Update(delta: float):
	Player.GetWallDirection()
	Player.HandleGravity(delta, Player.GravityJump)
	HandleWallKickMovement()
	HandleWallJumpEnd(delta)
	Player.HandleDash()
	HandleAnimations()


func HandleAnimations():
	if ((!Player.keyLeft and !Player.keyRight) and shouoldEnableWallKick):
		Player.Animator.play("WallKick")
		Player.Sprite.flip_h = (Player.velocity.x > 1)
	else:
		Player.Animator.play("WallJump")
		Player.Sprite.flip_h = (Player.velocity.x < 1)

func HandleWallJumpEnd(delta):
	if (Player.velocity.y >= Player.WallJumpYSpeedPeak):
		Player.ChangeState(States.Fall)
		
	if ((Player.wallDirection != lastWallDirection) and (Player.wallDirection != Vector2.ZERO)):
		Player.ChangeState(States.Fall)


func ShouldOnlyJumpButtonWallKick(shouldEnable: bool):
	shouoldEnableWallKick = shouldEnable
	if (shouldEnable):
		if (Player.keyLeft or Player.keyRight):
			Player.velocity.x = Player.WallJumpHSpeed * Player.wallDirection.x * -1
		else:
			if (Player.jumps == Player.MaxJumps):
				Player.velocity.x = Player.WallJumpHSpeed * Player.wallDirection.x * -1
			else:
				Player.ChangeState(States.Fall)
	else:
		Player.velocity.x = Player.WallJumpHSpeed * Player.wallDirection.x * -1

func HandleWallKickMovement():
	if (!Player.keyLeft and !Player.keyRight):
		Player.velocity.x = move_toward(Player.velocity.x, 0, Player.WallJumpAcceleration)
	else:
		if ((lastWallDirection == Vector2.LEFT and Player.keyRight)):
			Player.HorizontalMovement(Player.WallJumpAcceleration, Player.WallJumpAcceleration)
		elif ((lastWallDirection == Vector2.RIGHT and Player.keyLeft)):
			Player.HorizontalMovement(Player.WallJumpAcceleration, Player.WallJumpAcceleration)
