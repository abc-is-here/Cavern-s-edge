extends PlayerState

const WALL_MAG_SPEED = 50

func EnterState():
	Name = "wall_grab"
	player.velocity = Vector2.ZERO
	
	if player.wall_climb_dir == Vector2.LEFT:
		player.velocity.x = -WALL_MAG_SPEED
	elif player.wall_climb_dir == Vector2.RIGHT:
		player.velocity.x = WALL_MAG_SPEED

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	player.wall_release_handler()
	climb_handler()
	player.climb_stamina-=player.GRAB_STAMINA_COST
	player.handle_wall_jump()
	anim_handler()


func anim_handler():
	player.animation.play("wall_grab")
	player.sprite.flip_h = player.wall_climb_dir == Vector2.LEFT

func climb_handler():
	if player.key_up or player.key_down:
		player.change_state(States.wall_climb)
