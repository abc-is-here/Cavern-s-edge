extends PlayerState

func EnterState():
	Name = "idle"

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	player.fall_handler()
	player.jump_hndler()
	player.HorizontalMove()
	player.one_way_drop_handler()
	if player.move_dir_x != 0:
		player.change_state(States.run)
	player.dash_handler()
	anim_handle()

func anim_handle():
	player.animation.play("Idle")
	player.HandleFlipH()
