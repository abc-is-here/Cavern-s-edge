extends Node2D

func _process(delta: float) -> void:
	$Sprite2D.rotation_degrees+=1
	$Sprite2D2.rotation_degrees+=1
	$Sprite2D3.rotation_degrees+=1
	$Sprite2D4.rotation_degrees+=1
	$Sprite2D5.rotation_degrees+=1
	$Sprite2D6.rotation_degrees+=1
	$Sprite2D7.rotation_degrees+=1
	$Sprite2D8.rotation_degrees+=1
	$RotationPoints.rotation_degrees+=1
	$Sprite2D.global_position = $RotationPoints/Marker2D.global_position
	$Sprite2D2.global_position = $RotationPoints/Marker2D2.global_position
	$Sprite2D3.global_position = $RotationPoints/Marker2D3.global_position
	$Sprite2D4.global_position = $RotationPoints/Marker2D4.global_position
	$Sprite2D5.global_position = $RotationPoints/Marker2D5.global_position
	$Sprite2D6.global_position = $RotationPoints/Marker2D6.global_position
	$Sprite2D7.global_position = $RotationPoints/Marker2D7.global_position
	$Sprite2D8.global_position = $RotationPoints/Marker2D8.global_position
