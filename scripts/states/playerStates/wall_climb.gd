extends PlayerState


func EnterState():
	Name = "wall_climb"

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	player.can_climb_wall()
	player.climb_stamina -= player.CLIMB_STAMINA_COST
	climb_move_handler()
	player.wall_release_handler()
	player.handle_wall_jump()
	anim_handler()


func anim_handler():
	if player.velocity.y > 0:
		player.animation.speed_scale = -1
	else:
		player.animation.speed_scale= 1
	player.animation.play("wall_climb")
	player.sprite.flip_h = player.wall_climb_dir == Vector2.LEFT

func climb_move_handler():
	if player.key_climb:
		if player.wall_climb_dir != Vector2.ZERO:
			if player.key_up and (player.wall_climb_bound_top_left_rc.is_colliding() or player.wall_climb_bound_top_right_rc.is_colliding()):
				player.velocity.y = -player.CLIMB_SPEED
			elif player.key_down and (player.wall_climb_bound_bottom_left_rc.is_colliding() or player.wall_climb_bound_bottom_right_rc.is_colliding()):
				player.velocity.y = player.CLIMB_SPEED
			else:
				player.change_state(States.wall_grab)
		else:
			player.change_state(States.fall)
