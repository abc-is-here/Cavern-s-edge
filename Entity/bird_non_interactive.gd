extends Node2D

var birdSpeed = 100
var moving = false
var direction = Vector2.ZERO

func _ready() -> void:
	randomize()
	$AnimationPlayer.play("BirdIdle")
	$Area2D/Sprite2D2.visible = false

func _process(delta: float) -> void:
	if moving:
		position += direction * birdSpeed * delta
	if direction.x < 0:
			$Area2D/Sprite2D2.flip_h = true
	elif direction.x > 0:
		$Area2D/Sprite2D2.flip_h = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Area2D/Sprite2D2.visible = true
		$Area2D/Sprite2D.visible = false
		$AnimationPlayer.play("BirdFly")
		direction = Vector2(randf_range(-1, 1), randf_range(-1, -1)).normalized()
		moving = true
		await get_tree().create_timer(5).timeout
		queue_free()
