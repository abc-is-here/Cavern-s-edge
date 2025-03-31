extends Node2D

const maxrange = 5000

var based_width = 3

var widthy = based_width
var shoot = true
@export var direction: Vector2 = Vector2.RIGHT
@onready var collision = $Line2D/Area2D/CollisionShape2D

func _process(delta):
	$Line2D.width = widthy
	
	var max_cast_to = direction.rotated(rotation).normalized() * maxrange
	$RayCast2D.target_position = max_cast_to

	if $RayCast2D.is_colliding():
		$Reference.global_position = $RayCast2D.get_collision_point()
		$Line2D.set_point_position(1, $Line2D.to_local($Reference.global_position))
	else:
		$Reference.global_position = $RayCast2D.target_position
		$Line2D.points[1] = $Reference.global_position

	collision.shape.b = $Line2D.points[1]
	collision.disabled = false
	$Line2D.visible = true
