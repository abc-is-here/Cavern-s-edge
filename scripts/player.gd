extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var States: Node = $state_machine
@onready var camera: Camera2D = $Camera2D
@onready var jump_buffer_timer: Timer = $Timers/jump_buffer
@onready var coyote_timer: Timer = $Timers/coyoteTimer
@onready var bottom_left_rc: RayCast2D = $raycasts/wall_jump/bottom_left
@onready var bottom_right_rc: RayCast2D = $raycasts/wall_jump/bottom_right
@onready var wall_climb_top_left_rc: RayCast2D = $raycasts/wall_climb/wall_climb_top_left
@onready var wall_climb_bound_top_left_rc: RayCast2D = $raycasts/wall_climb/wall_climb_bound_top_left
@onready var wall_climb_top_right_rc: RayCast2D = $raycasts/wall_climb/wall_climb_top_right
@onready var wall_climb_bound_top_right_rc: RayCast2D = $raycasts/wall_climb/wall_climb_bound_top_right
@onready var wall_climb_bound_bottom_left_rc: RayCast2D = $raycasts/wall_climb/wall_climb_bound_bottom_left
@onready var wall_climb_bound_bottom_right_rc: RayCast2D = $raycasts/wall_climb/wall_climb_bound_bottom_right
@onready var dash_timer: Timer = $Timers/dash_timer
@onready var dash_buffer: Timer = $Timers/dash_buffer
@onready var dash_trail: CPUParticles2D = $FX/dash/trail


const RUNSPEED = 120
const GROUND_ACC = 40
const GROUND_DCC = 50
const GRAVITY_JUMP = 600
const JUMPVELOCITY = -240
const MAXJUMPS = 1
const GRAVITY_FALL = 750
const MAX_FALL_VELOCITY = 400
const VARIABLE_JUMP = 0.5
const JUMP_BUFFER = 0.15
const COYOTE_TIME = 0.1
const AIR_ACC = 15
const AIR_DCC = 20
const WALL_KICK_ACC = 4
const WALL_KICK_DCC = 5
const WALL_JUMP_SPEED_Y = 0
const WALL_JUMP_VEL = -190
const WALL_JUMP_H_SPEED = 120
const WALL_SLIDE_SPEED = 40
const CLIMB_SPEED = 30
const MAX_CLIMB_STAMINA = 300
const GRAB_STAMINA_COST = 1
const CLIMB_STAMINA_COST = 2
const MAX_DASHES = 1
const DASH_SPEED = 300
const DASH_ACC = 4
const DASH_TIME = 0.15
const DASH_BUFFER_TIME = 0.075
const carry_dash_moment = 0.5
const dash_delay_effect = 30

var move_speed = RUNSPEED
var jump_speed = JUMPVELOCITY
var move_dir_x = 0
var jumps = 0

var dashes = 0
var dash_dir: Vector2
var facing = 1

var ACC = GROUND_ACC
var DCC = GROUND_DCC

var wall_dir = Vector2.ZERO
var wall_climb_dir = Vector2.ZERO
var climb_stamina = MAX_CLIMB_STAMINA

var squish_X = 1.0
var squish_Y = 1.0
var squish_step = 0.02

var key_up = false
var key_down = false
var key_right = false
var key_left = false
var key_jump = false
var key_jump_pressed = false
var key_climb = false
var key_dash = false

var cur_state = null
var prev_state = null
var next_state = null

func _ready() -> void:
	for state in States.get_children():
		state.States = States
		state.player = self
	prev_state = States.fall
	cur_state = States.fall


func _draw() -> void:
	cur_state.Draw()

func _physics_process(delta: float) -> void:
	GetInputStates()
	Max_fall_velocity_handler()
	cur_state.update(delta)
	HorizontalMove()
	jump_hndler()
	move_and_slide()
	update_squish()
	state_change_handler()
	

func get_wall_dir():
	if bottom_right_rc.is_colliding():
		wall_dir = Vector2.RIGHT
	elif bottom_left_rc.is_colliding():
		wall_dir = Vector2.LEFT
	else:
		wall_dir = Vector2.ZERO
	
	# Debugging
	#print("Wall direction: ", wall_dir)

func GetInputStates():
	key_up = Input.is_action_pressed("up")
	key_down = Input.is_action_pressed("down")
	key_right = Input.is_action_pressed("move_right")
	key_left = Input.is_action_pressed("move_left")
	key_jump = Input.is_action_pressed("jump")
	key_jump_pressed = Input.is_action_just_pressed("jump")
	key_climb = Input.is_action_pressed("climb")
	key_dash = Input.is_action_just_pressed("dash")
	
	if (key_right): facing = 1
	if (key_left): facing = -1

func wall_grab_handler():
	can_climb_wall()
	if wall_climb_dir != Vector2.ZERO and key_climb and climb_stamina > 0:
		velocity.x = 0
		velocity.y = -CLIMB_SPEED
		climb_stamina -= CLIMB_STAMINA_COST
		change_state(States.wall_grab)
	else:
		wall_release_handler()


func HorizontalMove(acc: float = ACC, dcc: float = DCC):
	if cur_state == States.wall_grab:
		velocity.x = 0
		return

	move_dir_x = Input.get_axis("move_left", "move_right")
	if move_dir_x != 0:
		velocity.x = move_toward(velocity.x, move_dir_x * move_speed, acc)
	else:
		velocity.x = move_toward(velocity.x, move_dir_x * move_speed, dcc)
		
func wall_slide_handler():
	if ((wall_dir == Vector2.LEFT and key_left) and (wall_climb_top_left_rc.is_colliding() and bottom_left_rc.is_colliding())
		or (wall_dir == Vector2.RIGHT and key_right) and (wall_climb_top_right_rc.is_colliding() and bottom_right_rc.is_colliding())):
			if !key_jump:
				change_state(States.wall_slide)
			
func fall_handler():
	if not is_on_floor():
		coyote_timer.start(COYOTE_TIME)
		change_state(States.fall)

func can_climb_wall():
	if bottom_left_rc.is_colliding() and wall_climb_top_left_rc.is_colliding():
		wall_climb_dir = Vector2.LEFT
	elif bottom_right_rc.is_colliding() and wall_climb_top_right_rc.is_colliding():
		wall_climb_dir = Vector2.RIGHT
	else:
		wall_climb_dir = Vector2.ZERO

func Land_handler():
	if is_on_floor():
		jumps = 0
		dashes = 0
		climb_stamina = MAX_CLIMB_STAMINA
		change_state(States.idle)

func handle_wall_jump():
	get_wall_dir()
	if (key_jump_pressed or jump_buffer_timer.time_left > 0) and wall_dir != Vector2.ZERO:
		velocity.y = WALL_JUMP_VEL
		velocity.x = WALL_JUMP_H_SPEED * -wall_dir.x
		jumps += 1
		change_state(States.wall_jump)
		

func get_grav(delta, grav: float = GRAVITY_JUMP):
	if not is_on_floor():
		velocity.y+=grav*delta

func jump_hndler():
	if is_on_floor():
		if jumps<MAXJUMPS:
			if key_jump_pressed or jump_buffer_timer.time_left>0:
				jump_buffer_timer.stop()
				jumps+=1
				change_state(States.jump)
			if jump_buffer_timer.time_left > 0:
				jumps+=1
				jump_buffer_timer.stop()
				change_state(States.jump)
	else:
		if ((jumps<MAXJUMPS) and (jumps>0) and key_jump_pressed):
			jumps+=1
			change_state(States.jump)
		
		if coyote_timer.time_left > 0:
			if (key_jump_pressed and jumps<MAXJUMPS):
				coyote_timer.stop()
				jumps+=1
				change_state(States.jump)

func change_state(target_state):
	if target_state:
		next_state = target_state

func state_change_handler():
	if next_state != null:
		if cur_state != next_state:
			prev_state = cur_state
			cur_state.ExitState()
			cur_state = null
			cur_state = next_state
			cur_state.EnterState()
		next_state = null

func wall_release_handler():
	if (!key_climb or climb_stamina <= 0) and is_on_wall():
		change_state(States.fall)

func Max_fall_velocity_handler():
	if velocity.y > MAX_FALL_VELOCITY:
		velocity.y = MAX_FALL_VELOCITY

func HandleFlipH():
	sprite.flip_h = (facing<1)

func jump_buffer_handler():
	if key_jump_pressed:
		jump_buffer_timer.start(JUMP_BUFFER)

func update_squish():
	sprite.scale.x = squish_X
	sprite.scale.y = squish_Y
	
	if squish_X != 0.1:
		squish_X = move_toward(squish_X, 1.0, squish_step)
	if squish_Y != 0.1:
		squish_Y = move_toward(squish_Y, 1.0, squish_step)

func set_squish(_squish_X: float = 1.0, _squish_Y: float = 1.0, _step: float = squish_step):
	squish_X = _squish_X if _squish_X != 0 else 1.0
	squish_Y = _squish_Y if _squish_Y != 0 else 1.0
	squish_step = _step if _step!=0 else squish_step

func dash_handler():
	if dashes<MAX_DASHES:
		if key_dash:
			if dash_timer.time_left <= 0:
				dash_timer.start(DASH_BUFFER_TIME)
				await dash_timer.timeout
				dashes+=1
				change_state(States.dash)

func get_dash_dir() -> Vector2:
	var _dir = Vector2.ZERO
	if !key_left and !key_right and !key_up and !key_down:
		_dir = Vector2(facing, 0)
	else:
		_dir = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("up", "down"))
	return _dir
	
