class_name Wall_jump
extends PlayerState

var last_wall_dir
var enable_wall_kick

func EnterState():
	Name = "wall_jump"
	player.velocity.y = player.WALL_JUMP_VEL
	last_wall_dir = player.wall_dir
	Jump_button_wall_kick(false)

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	anim_handle()
	player.get_wall_dir()
	player.get_grav(delta, player.GRAVITY_JUMP)
	wall_jump_handler()
	Wall_kick_handler()
	player.dash_handler()

func wall_jump_handler():
	if player.velocity.y >= player.WALL_JUMP_SPEED_Y:
		player.change_state(States.fall)
	
	if (player.wall_dir != last_wall_dir) and player.wall_dir != Vector2.ZERO:
		player.change_state(States.fall)

func anim_handle():
	if (!player.key_left and !player.key_right) and enable_wall_kick:
		player.animation.play("kick_wall")
		player.sprite.flip_h = player.velocity.x > 1
		
	else:
		player.animation.play("jump_wall")
		player.sprite.flip_h = player.velocity.x < 0

func Jump_button_wall_kick(enabled: bool):
	enable_wall_kick = enabled
	if enabled:
		if player.key_left or player.key_right:
			player.velocity.x = player.WALL_JUMP_H_SPEED*player.wall_dir.x*-1
		else:
			if (player.jumps == player.MAXJUMPS):
				player.velocity.x = player.WALL_JUMP_H_SPEED * player.wall_dir.x*-1
			else:
				player.change_state(States.fall)
	else:
		player.velocity.x = player.WALL_JUMP_H_SPEED * player.wall_dir.x*-1

func Wall_kick_handler():
	if !player.key_left and !player.key_right:
		player.velocity.x = move_toward(player.velocity.x, 0, player.WALL_KICK_ACC)
	else:
		if (last_wall_dir == Vector2.LEFT) and player.key_right:
			player.HorizontalMove(player.WALL_KICK_ACC, player.WALL_KICK_DCC)
		elif (last_wall_dir == Vector2.RIGHT) and player.key_left:
			player.HorizontalMove(player.WALL_KICK_ACC, player.WALL_KICK_DCC)
