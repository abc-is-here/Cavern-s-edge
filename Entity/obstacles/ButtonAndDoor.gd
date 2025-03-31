extends Node2D

func _ready() -> void:
	$Area2D/button_pressed.visible = false



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("box"):
		$Area2D/button.visible = false
		$Area2D/button_pressed.visible = true
		$Door.position.y += 60

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player") or body.is_in_group("box"):
		$Area2D/button.visible = true
		$Area2D/button_pressed.visible = false
		$Door.position.y -= 60
