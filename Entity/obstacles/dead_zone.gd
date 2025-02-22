extends Area2D

var checkPointManager
var Player

func _ready() -> void:
	checkPointManager = get_parent().get_node("CheckPointManager")
	Player = get_parent().get_node("Player")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Dead")
		KillPlayer()

func KillPlayer():
	print("Respawning player at:", checkPointManager.lastLocation)
	Player.global_position = checkPointManager.lastLocation
