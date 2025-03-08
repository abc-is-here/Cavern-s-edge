extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("powerUp")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.is_immune = true
		visible = false
		await get_tree().create_timer(5).timeout
		Global.is_immune = false
		visible = true
		
