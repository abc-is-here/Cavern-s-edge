class_name PlayerController extends CharacterBody2D

@onready var Sprite = $Sprite
@onready var Animator = $Animator
@onready var Collider = $Collider
@onready var States = $StateMachine

@onready var CoyoteTimer = $Timers/CoyoteTime
@onready var JumpBufferTimer = $Timers/JumpBuffer
@onready var DashTimer = $Timers/DashTimer
@onready var DashBuffer = $Timers/DashBuffer

@onready var Raycasts = $Raycasts
@onready var RCBottomLeft = $Raycasts/WallJump/BottomLeft
@onready var RCBottomRight = $Raycasts/WallJump/BottomRight
@onready var RCTopRight = $Raycasts/WallClimb/TopRight
@onready var RCTopLeft = $Raycasts/WallClimb/TopLeft
@onready var RCUpperLeft = $Raycasts/WallClimb/UpperLeft
@onready var RCUpperRight = $Raycasts/WallClimb/UpperRight
@onready var RCLowerLeft = $Raycasts/WallClimb/LowerLeft
@onready var RCLowerRight = $Raycasts/WallClimb/LowerRight

@onready var RCLedgeRightLower = $Raycasts/LedgeGrab/LedgeRightLower
@onready var RCLedgeRightUpper = $Raycasts/LedgeGrab/LedgeRightUpper
@onready var RCLedgeLeftLower = $Raycasts/LedgeGrab/LedgeLeftLower
@onready var RCLedgeLeftUpper = $Raycasts/LedgeGrab/LedgeLeftUpper

@onready var DashParticles = $GraphcisEffects/Dash/DashTrail

@export var CollisionMap: TileMapLayer

const RunSpeed = 120
const WallJumpHSpeed = 120
const GroundAcceleration = 20
const GroundDeceleration = 25
const AirAcceleration = 15
const AirDeceleration = 20
const WallKickAcceleration = 4
const GravityJump = 600
const GravityFall = 700
const MaxFallVelocity = 300

const JumpVelocity = -240
const WallJumpVelocity = -190
const WallJumpAcceleration = 5
const WallJumpYSpeedPeak = 0
const VariableJumpMultiplier = 0.5
const MaxJumps = 1
const CoyoteTime = 0.1
const JumpBufferTime = 0.15

const ClimbSpeed = 30
const MaxClimbStamina = 300
const GrabStaminaCost = 1
const ClimbStaminaCost = 2
const WallSlideSpeed = 40

const MaxDashes = 1
const DashSpeed = 300
const DashDeceleration = 4
const DashTime = 0.15
const DashBufferTime = 0.075
const DashDelayEffect = 30

var moveSpeed = RunSpeed
var Acceleration = GroundAcceleration
var Deceleration = GroundDeceleration
var moveDirectionX = 0
var movingPlatformSpeed = Vector2(0, 0)
var movingPlatformSpeedBonus = Vector2(0, 0)
var moveSpeedBonus = 0

var jumpSpeed = JumpVelocity
var jumps = 0

var wallDirection: Vector2 = Vector2.ZERO
var wallClimbDirection: Vector2 = Vector2.ZERO
var climbStamina = MaxClimbStamina

var dashes = 0
var dashDirection: Vector2
var facing = 1

var squishX = 1.0
var squishY = 1.0
var squishStep = 0.02

var ledgeDirection: Vector2 = Vector2.ZERO
var cornerGrabPosition: Vector2 = Vector2.ZERO
var ResettingPlatformNudge: int = -8
var AdditionalLedgeClimbNudge: int = 0

var movingPlatform: MovingPlatform = null
var movingPlatformOffset: Vector2 = Vector2.ZERO
var movingPlatformJumpMomentum: Vector2 = Vector2.ZERO
var movingPlatformCornerGrabPosition: Vector2 = Vector2.ZERO
var MovingPlatformNudge: int = -12
var PlayerColliderExtents

var resettingPlatform: ResettingPlatform = null

var keyUp = false
var keyUpPressed = false
var keyDown = false
var keyLeft = false
var keyRight = false
var keyJump = false
var keyJumpPressed = false
var keyClimb = false
var keyDash = false

var currentState = null
var previousState = null
var nextState = null

func _ready():
	for state in States.get_children():
		state.States = States
		state.Player = self
	previousState = States.Fall
	currentState = States.Fall
	
	CoyoteTimer.one_shot = true
	JumpBufferTimer.one_shot = true

	PlayerColliderExtents = Collider.shape.extents


func _draw():
	currentState.Draw()


func _physics_process(delta: float) -> void:

	GetInputStates()
	UpdateRaycasts()

	currentState.Update(delta)
	HandleMaxFallVelocity()
	UpdateSquish()

	move_and_slide()
	movingPlatformSpeed = get_platform_velocity()

	if (!movingPlatform):
		movingPlatformCornerGrabPosition = Vector2.ZERO

func HorizontalMovement(acceleration: float = Acceleration, deceleration: float = Deceleration):
	moveDirectionX = Input.get_axis("Left", "Right")
	var _targetSpeed = moveDirectionX * (moveSpeed) + movingPlatformSpeedBonus.x + moveSpeedBonus
	
	if (moveDirectionX != 0):
		velocity.x = move_toward(velocity.x, _targetSpeed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, _targetSpeed, deceleration)


func HandleFalling():
	if (!is_on_floor()):
		CoyoteTimer.start(CoyoteTime)
		ChangeState(States.Fall)


func HandleMaxFallVelocity():
	if (velocity.y > MaxFallVelocity): velocity.y = MaxFallVelocity


func HandleJumpBuffer():
	if (keyJumpPressed and (CoyoteTimer.time_left <= 0)):
		JumpBufferTimer.start(JumpBufferTime)


func HandleGravity(delta, gravity: float = GravityJump):
	velocity.y += gravity * delta


func HandleJump():
	if (is_on_floor()):
		if (jumps < MaxJumps):
			if (keyJumpPressed):
				jumps += 1
				ChangeState(States.Jump)
			if (JumpBufferTimer.time_left > 0):
				JumpBufferTimer.stop()
				ChangeState(States.Jump)
	else:
		if ((jumps < MaxJumps) and (jumps > 0) and keyJumpPressed):
			jumps += 1
			ChangeState(States.Jump)
		if (CoyoteTimer.time_left > 0):
			if ((keyJumpPressed) and (jumps < MaxJumps)):
				CoyoteTimer.stop()
				jumps += 1
				ChangeState(States.Jump)


func HandleWallJump():
	if (movingPlatform):
		movingPlatformJumpMomentum = movingPlatform.GetVelocity()
	else:
		movingPlatformJumpMomentum = Vector2.ZERO
	
	GetWallDirection()
	if ((keyJumpPressed or (JumpBufferTimer.time_left > 0)) and wallDirection.x != 0):
		ChangeState(States.WallJump)


func HandleLanding():
	if (is_on_floor()):
		jumps = 0
		dashes = 0
		climbStamina = MaxClimbStamina
		ChangeState(States.Idle)


func HandleWallGrab():
	if (wallClimbDirection != Vector2.ZERO):
		if (keyClimb and (climbStamina > 0)):
			ChangeState(States.WallGrab)


func HandleWallRelease():
	if (!keyClimb):
		ChangeState(States.Fall)
	elif (climbStamina <= 0):
		ChangeState(States.Fall)
	elif (wallClimbDirection == Vector2.ZERO):
		ChangeState(States.Fall)


func HandleWallSlide():
	if (((wallDirection == Vector2.LEFT and keyLeft) and (RCUpperLeft.is_colliding() and RCLowerLeft.is_colliding()))
		or ((wallDirection == Vector2.RIGHT and keyRight) and (RCUpperRight.is_colliding() and RCLowerRight.is_colliding()))):
		if (!keyJump):
			if (IsRayCastCollidingMovingPlatform(RCUpperLeft)
				or IsRayCastCollidingMovingPlatform(RCLowerLeft)
				or IsRayCastCollidingMovingPlatform(RCUpperRight)
				or IsRayCastCollidingMovingPlatform(RCLowerRight)):
				return
			else:
				ChangeState(States.WallSlide)


func HandleDash():
	if (dashes < MaxDashes):
		if (keyDash):
			if (DashTimer.time_left <= 0):
				DashTimer.start(DashBufferTime)
				await DashTimer.timeout
				dashes += 1
				ChangeState(States.Dash)


func GetDashDirection() -> Vector2:
	var _dir = Vector2.ZERO
	if (!keyLeft and !keyRight and !keyUp and !keyDown):
		_dir = Vector2(facing, 0)
	else:
		_dir -= Vector2(Input.get_axis("Right", "Left"), Input.get_axis("Down", "Up"))
	return _dir


func HandleLedgeGrab():
	var _tileSize = CollisionMap.tile_set.tile_size
	var _tileSizeCorrection = (_tileSize / 2) as Vector2
	var _collisionPoint
	var _tileCoords
	
	if (RCLedgeLeftLower.is_colliding() and !RCLedgeLeftUpper.is_colliding()):
		if (facing == -1):
			if (RCLedgeLeftLower.get_collider().get_parent() is MovingPlatform):
				movingPlatform = RCLedgeLeftLower.get_collider().get_parent()
				var _positionalAdjustment = Vector2(movingPlatform.GetExtents().x, -movingPlatform.GetExtents().y)
				movingPlatformCornerGrabPosition = _positionalAdjustment
				AdditionalLedgeClimbNudge = ResettingPlatformNudge
				ChangeState(States.LedgeGrab)
			if (RCLedgeLeftLower.get_collider() is ResettingPlatform):
				resettingPlatform = RCLedgeLeftLower.get_collider()
				var _positionAdjustment = Vector2(resettingPlatform.Collider.shape.extents.x, -resettingPlatform.Collider.shape.extents.y)
				
				cornerGrabPosition = resettingPlatform.global_position + _positionAdjustment
				AdditionalLedgeClimbNudge = ResettingPlatformNudge
				resettingPlatform.currentState = resettingPlatform.PlatformStates.Breaking
				
				ChangeState(States.LedgeGrab)
			else:
				_collisionPoint = RCLedgeLeftLower.get_collision_point()
				_tileCoords = CollisionMap.local_to_map(_collisionPoint)
				AdditionalLedgeClimbNudge = 0
				
				var _ledge = Vector2i(_tileCoords.x + facing, _tileCoords.y)
				var _tileData = CollisionMap.get_cell_tile_data(_ledge)
				if (_tileData and (_tileData.get_custom_data("OneWay"))):
					ChangeState(States.Fall)
					return
				else:
					cornerGrabPosition = CollisionMap.map_to_local(_tileCoords) - _tileSizeCorrection
					ChangeState(States.LedgeGrab)
	
	
	if (RCLedgeRightLower.is_colliding() and !RCLedgeRightUpper.is_colliding()):
		if (facing == 1):
			if (RCLedgeRightLower.get_collider().get_parent() is MovingPlatform):
				movingPlatform = RCLedgeRightLower.get_collider().get_parent()
				var _positionalAdjustment = Vector2(-movingPlatform.GetExtents().x, -movingPlatform.GetExtents().y)
				movingPlatformCornerGrabPosition = _positionalAdjustment
				AdditionalLedgeClimbNudge = ResettingPlatformNudge
				ChangeState(States.LedgeGrab)
			if (RCLedgeRightLower.get_collider() is ResettingPlatform):
				resettingPlatform = RCLedgeRightLower.get_collider()
				var _positionAdjustment = Vector2(-resettingPlatform.Collider.shape.extents.x, -resettingPlatform.Collider.shape.extents.y)
				
				cornerGrabPosition = resettingPlatform.global_position + _positionAdjustment
				AdditionalLedgeClimbNudge = ResettingPlatformNudge
				resettingPlatform.currentState = resettingPlatform.PlatformStates.Breaking
				
				ChangeState(States.LedgeGrab)
			else:
				_collisionPoint = RCLedgeRightLower.get_collision_point()
				_tileCoords = CollisionMap.local_to_map(_collisionPoint)
				AdditionalLedgeClimbNudge = 0
				
				var _ledge = Vector2i(_tileCoords.x + facing, _tileCoords.y)
				var _tileData = CollisionMap.get_cell_tile_data(_ledge)
				if (_tileData and (_tileData.get_custom_data("OneWay"))):
					ChangeState(States.Fall)
					return
				else:
					cornerGrabPosition = CollisionMap.map_to_local(_tileCoords) - _tileSizeCorrection
					ChangeState(States.LedgeGrab)


func HandleOneWayDropThrough():
	if (keyDown):
		global_position += Vector2(0, 1)

func UpdateRaycasts():
	for child in Raycasts.get_children():
		if child is RayCast2D:
			child.force_raycast_update()


func GetWallDirection():
	if (RCBottomLeft.is_colliding()):
		wallDirection = Vector2.LEFT
	elif (RCBottomRight.is_colliding()):
		wallDirection = Vector2.RIGHT
	else:
		wallDirection = Vector2.ZERO


func GetCanWallClimb():
	if (RCBottomLeft.is_colliding() and RCTopLeft.is_colliding()):
		if ((RCBottomLeft.get_collider().get_parent() is MovingPlatform)
			or (RCTopLeft.get_collider().get_parent() is MovingPlatform)):
			wallClimbDirection = Vector2.LEFT
			movingPlatform = RCBottomLeft.get_collider().get_parent()
		else:
			wallClimbDirection = Vector2.LEFT
			movingPlatform = null
	elif (RCBottomRight.is_colliding() and RCTopRight.is_colliding()):
		if ((RCBottomRight.get_collider().get_parent() is MovingPlatform)
			or (RCTopRight.get_collider().get_parent() is MovingPlatform)):
			wallClimbDirection = Vector2.RIGHT
			movingPlatform = RCBottomLeft.get_collider().get_parent()
		else:
			wallClimbDirection = Vector2.RIGHT
			movingPlatform = null
	else:
		wallClimbDirection = Vector2.ZERO


func GetInputStates():
	keyUp = Input.is_action_pressed("Up")
	keyUpPressed = Input.is_action_just_pressed("Up")
	keyDown = Input.is_action_pressed("Down")
	keyLeft = Input.is_action_pressed("Left")
	keyRight = Input.is_action_pressed("Right")
	keyJump = Input.is_action_pressed("Jump")
	keyJumpPressed = Input.is_action_just_pressed("Jump")
	keyClimb = Input.is_action_pressed("Climb")
	keyDash = Input.is_action_just_pressed("Dash")
	
	if (keyLeft): facing = -1
	if (keyRight): facing = 1
	Sprite.flip_h = (facing < 0)


func ChangeState(nextState):
	if (nextState != null):
		if (currentState != nextState):
			previousState = currentState
			currentState.ExitState()
			currentState = null
			currentState = nextState
			currentState.EnterState()
		nextState = null


func IsRayCastCollidingMovingPlatform(_ray: RayCast2D) -> bool:
	if(_ray.is_colliding()):
		var _parent = _ray.get_collider().get_parent()
		if (_parent is MovingPlatform):
			return true
		else:
			return false
	else:
		return false

func UpdateSquish():
	Sprite.scale.x = squishX
	Sprite.scale.y = squishY
	
	if (squishX != 1.0):
		squishX = move_toward(squishX, 1.0, squishStep)
	if (squishY != 1.0):
		squishY = move_toward(squishY, 1.0, squishStep)

func SetSquish(_squishX: float = 1.0, _squishY: float = 1.0, _step: float = 0.02):
	squishX = _squishX if (_squishX != 0) else 1
	squishY = _squishY if (_squishY != 0) else 1
	squishStep = _step


func HandleFlipH():
	Sprite.flip_h = (facing < 1)
