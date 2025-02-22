extends PlayerState

const WallMagnetSpeed = 50

func EnterState():
	Name = "WallGrab"
	Player.velocity = Vector2.ZERO
	
	if (Player.wallClimbDirection == Vector2.LEFT):
		Player.velocity.x = -WallMagnetSpeed
	elif (Player.wallClimbDirection == Vector2.RIGHT):
		Player.velocity.x = WallMagnetSpeed
	
	if (Player.movingPlatform):
		var xOffset = (Player.movingPlatform.GetExtents().x + Player.PlayerColliderExtents.x) * Player.wallClimbDirection.x * -1
		var yOffset = Player.global_position.y - Player.movingPlatform.GetPosition().y
		Player.movingPlatformOffset = Vector2(xOffset, yOffset)


func ExitState():
	pass


func Draw():
	pass


func Update(delta):
	Player.GetCanWallClimb()
	
	if (Player.movingPlatform):
		Player.global_position = Player.movingPlatform.GetPosition() + Player.movingPlatformOffset
	
	Player.HandleWallRelease()
	HandleClimb()
	Player.climbStamina -= Player.GrabStaminaCost
	Player.HandleWallJump()
	#Player.HandleDash()
	HandleAnimations()


func HandleClimb():
	if (Player.keyUp or Player.keyDown):
		Player.ChangeState(States.WallClimb)


func HandleAnimations():
	Player.Animator.play("WallGrab")
	Player.Sprite.flip_h = (Player.wallClimbDirection == Vector2.LEFT)
