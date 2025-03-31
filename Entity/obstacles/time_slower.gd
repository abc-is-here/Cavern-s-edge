extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.slow_time(7, 0.1)
		$Area2D/Sprite2D.visible = false
		await get_tree().create_timer(1).timeout
		$Area2D/Sprite2D.visible = true
