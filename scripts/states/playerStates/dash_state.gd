extends PlayerState

const dash_squish = 0.25
const dist_effect = preload("res://scenes/distort.tscn")

func EnterState():
	Name = "dash"
	OS.delay_msec(player.dash_delay_effect)
	player.dash_dir= player.get_dash_dir()
	player.dash_trail.restart()
	player.velocity = player.dash_dir.normalized() * player.DASH_SPEED
	player.dash_timer.start(player.DASH_TIME)
	player.set_squish(abs(player.dash_dir.y * dash_squish), abs(player.dash_dir.x * dash_squish))
	var _distortion = dist_effect.instantiate()
	_distortion.global_position = player.global_position
	get_tree().root.get_node("world").add_child(_distortion)
	player.animation.play("dash")
	player.HandleFlipH()

func ExitState():
	pass

func update(delta: float):
	dash_end_handler()
	anim_handle()

func dash_end_handler():
	if player.dash_timer.time_left <= 0:
		player.dash_timer.stop()
		player.velocity *= player.carry_dash_moment
		player.change_state(States.fall)

func anim_handle():
	player.animation.play("dash")
	player.HandleFlipH()
