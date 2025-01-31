extends PlayerState

func EnterState():
	Name = "peak_jump"

func ExitState():
	pass

func update(delta: float):
	player.change_state(States.fall)

func anim_handle():
	pass
