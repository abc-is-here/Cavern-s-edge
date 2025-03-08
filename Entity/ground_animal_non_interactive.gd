extends Node2D

var Speed = 100
var moving = false
var direction = Vector2.ZERO

func _ready() -> void:
	randomize()
	$GroundAnimalsNonInteractive/Run.visible = false
	$AnimationPlayer.play("RabbitIdle")

func _process(delta: float) -> void:
	if moving:
		position += direction * Speed * delta
	if direction.x < 0:
			$GroundAnimalsNonInteractive/Run.flip_h = true
	elif direction.x > 0:
		$GroundAnimalsNonInteractive/Run.flip_h = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$GroundAnimalsNonInteractive/Idle.visible = false
		$GroundAnimalsNonInteractive/Run.visible = true
		$AnimationPlayer.play("RabbitRun")
		direction = Vector2(randf_range(-1, 1), randf_range(0, 0)).normalized()
		moving = true
		await get_tree().create_timer(5).timeout
		queue_free()
		
