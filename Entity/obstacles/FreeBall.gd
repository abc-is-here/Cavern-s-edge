extends Node2D

var stone_in_area = false

func _ready() -> void:
	global_position = $Marker2D.global_position

func _on_ball_end_body_entered(body: Node2D) -> void:
	if body is Stone:
		body.global_position = $Marker2D.global_position
		stone_in_area = true
	else:
		stone_in_area = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and stone_in_area:
		Global.emit_signal("RockFall")
