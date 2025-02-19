extends PlayerState

const ledge_final_pos_x = 10
const ledge_final_pos_y = -14

var ledge_grab_final_pos = Vector2.ZERO


func EnterState():
	Name = "ledge_climb"
	if player.ledge_left_lower_rc.is_colliding():
		player.ledge_dir = Vector2.LEFT
	if player.ledge_right_lower_rc.is_colliding():
		player.ledge_dir = Vector2.RIGHT
	
	ledge_grab_final_pos = Vector2(ledge_final_pos_x*player.ledge_dir.x, ledge_final_pos_y)

func ExitState():
	pass

func Draw():
	pass
	
func update(delta: float):
	climb_up_handler()
	anim_handler()

func climb_up_handler():
	player.animation.play("ledge_climb")
	
func anim_handler():
	player.sprite.flip_h = player.ledge_dir.x < 0

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "ledge_climb":
		player.global_position += ledge_grab_final_pos
		player.change_state(States.idle)
