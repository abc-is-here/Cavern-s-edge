extends Area2D

var checkPointManager
var Player

func _ready() -> void:
	checkPointManager = get_tree().get_first_node_in_group("CheckPointManager")
	Player = get_tree().get_first_node_in_group("Player")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !Global.is_immune:
		Global.emit_signal("shake_camera")
		Global.is_in_deadzone = true
		KillPlayer()
	else:
		Global.is_in_deadzone = false

func KillPlayer():
	Player.global_position = checkPointManager.lastLocation
	
