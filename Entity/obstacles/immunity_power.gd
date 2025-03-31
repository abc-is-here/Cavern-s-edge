extends Node2D


func _ready() -> void:
	$AnimationPlayer.play("powerUp")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.is_immune = true
		body.MaxJumps = 2
		body.MaxDashes = 2
		visible = false
		await get_tree().create_timer(5).timeout
		Global.is_immune = false
		body.MaxJumps = 1
		body.MaxDashes = 1
		visible = true
		
