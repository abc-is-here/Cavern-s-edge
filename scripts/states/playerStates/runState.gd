extends PlayerState

func EnterState():
	Name = "run"

func ExitState():
	pass

func update(delta: float):
	player.HorizontalMove()
	player.jump_hndler()
	player.fall_handler()
	player.dash_handler()
	player.one_way_drop_handler()
	anim_handle()
	idle_handle()

func idle_handle():
	if player.move_dir_x == 0:
		player.change_state(States.idle)

func anim_handle():
	player.animation.play("run")
