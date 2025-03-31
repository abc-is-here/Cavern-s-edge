extends Node2D

func _ready() -> void:
	if $CharacterBody2D.has_node("CollisionPolygon2D"):
		$CharacterBody2D/CollisionPolygon2D.set_deferred("disabled", true)
	else:
		push_error("CollisionPolygon2D not found in CharacterBody2D")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.player_in_bubble = true
		if $CharacterBody2D.has_node("CollisionPolygon2D"):
			$CharacterBody2D/CollisionPolygon2D.set_deferred("disabled", false)
		else:
			push_error("CollisionPolygon2D not found in CharacterBody2D")

func _on_area_2d_body_exited(body: Node2D) -> void:
	Global.player_in_bubble = false
