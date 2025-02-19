extends PlayerState

const ledge_release_x_nudge = 1
const ledge_release_y_nudge = 5
const ledge_grab_snap_y = 6

var corner_grab_pos = Vector2.ZERO
var ledge_grab_snap_pos = Vector2.ZERO

func EnterState():
	
	Name = "ledge_grab"
	
	if player.ledge_left_lower_rc.is_colliding():
		player.ledge_dir = Vector2.LEFT
	if player.ledge_right_lower_rc.is_colliding():
		player.ledge_dir = Vector2.RIGHT

	var _tile_size = player.collision_map.tile_set.tile_size
	var _tile_size_correction = _tile_size/2 as Vector2
	var _collision_point
	var _tile_coords
	if player.ledge_dir == Vector2.LEFT:
		if player.ledge_left_lower_rc.is_colliding():
			_collision_point = player.ledge_left_lower_rc.get_collision_point()
			_tile_coords = player.collision_map.local_to_map(_collision_point)
			corner_grab_pos = player.collision_map.map_to_local(_tile_coords) - _tile_size_correction
		if player.ledge_right_lower_rc.is_colliding():
			_collision_point = player.ledge_right_lower_rc.get_collision_point()
			_tile_coords = player.collision_map.local_to_map(_collision_point)
			corner_grab_pos = player.collision_map.map_to_local(_tile_coords) - _tile_size_correction
		
		ledge_grab_snap_pos = Vector2(corner_grab_pos.x + (player.ledge_dir.x * -1), corner_grab_pos.y + ledge_grab_snap_y)
		player.global_position = ledge_grab_snap_pos

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	player.climb_stamina -= player.GRAB_STAMINA_COST
	jump_up_handler()
	climb_up_handler()
	ledge_release_handler()
	anim_handler()

func ledge_release_handler():
	if player.key_down or player.climb_stamina <= 0:
		player.global_position+=Vector2(ledge_release_x_nudge*player.ledge_dir.x*-1, ledge_release_y_nudge)
		player.change_state(States.fall)

func jump_up_handler():
	if player.key_jump_pressed:
		player.global_position+=Vector2(ledge_release_x_nudge*player.ledge_dir.x*-2, ledge_release_y_nudge)
		player.change_state(States.jump)

func climb_up_handler():
	if player.key_up_pressed:
		player.change_state(States.ledge_climb)

func anim_handler():
	player.animation.play("ledge_grab")
	player.sprite.flip_h = player.ledge_dir.x < 0
	
