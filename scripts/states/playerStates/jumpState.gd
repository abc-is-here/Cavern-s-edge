extends PlayerState

func EnterState():
	Name = "jump"
	player.velocity.y = player.jump_speed
	player.moving_plat_momentum+= player.moving_plat_speed

func ExitState():
	pass

func update(delta: float):
	player.HorizontalMove()
	player.get_grav(delta)
	anim_handle()
	player.dash_handler()
	player.wall_grab_handler()
	player.handle_wall_jump()
	player.ledge_grab_handler()

	jumpFall_handle()

func jumpFall_handle():
	if player.velocity.y >= 0:
		player.change_state(States.fall)

	if not player.key_jump:
		player.velocity.y *= player.VARIABLE_JUMP
		player.change_state(States.fall)

func anim_handle():
	player.animation.play("jump")
	player.HandleFlipH()
