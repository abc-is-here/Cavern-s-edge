extends PlayerState

func EnterState():
	Name = "fall"

func ExitState():
	pass

func update(delta: float):
	player.HorizontalMove(player.AIR_ACC, player.AIR_DCC)
	player.Land_handler()
	player.get_grav(delta, player.GRAVITY_FALL)
	player.jump_hndler()
	player.jump_buffer_handler()
	player.handle_wall_jump()
	player.wall_slide_handler()
	player.wall_grab_handler()
	player.dash_handler()
	anim_handle()

func anim_handle():
	player.animation.play("fall")
	player.HandleFlipH()
