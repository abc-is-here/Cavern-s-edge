extends PlayerState

const wall_mag_speed = 50

func EnterState():
	Name = "wall_slide"
	if player.wall_dir == Vector2.LEFT:
		player.velocity.x = -wall_mag_speed
	elif player.wall_dir == Vector2.RIGHT:
		player.velocity.x = wall_mag_speed

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	player.get_wall_dir()
	player.Land_handler()
	player.handle_wall_jump()
	wall_slide_move_handler()
	anim_handler()


func anim_handler():
	player.animation.play("wall_slide")
	player.sprite.flip_h = player.wall_climb_dir == Vector2.LEFT

func wall_slide_move_handler():
	if player.wall_climb_dir == Vector2.ZERO:
		player.change_state(States.fall)
	
	if (player.wall_climb_dir == Vector2.LEFT and player.key_left) or (player.wall_climb_dir == Vector2.RIGHT and player.key_right):
		if (!player.key_jump):
			player.velocity.y = player.WALL_SLIDE_SPEED
	else:
		player.change_state(States.fall)
