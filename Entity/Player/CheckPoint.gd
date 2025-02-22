extends Area2D

var checkPointManager

func _ready() -> void:
	checkPointManager = get_parent().get_parent().get_node("CheckPointManager")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Checkpoint reached, updating respawn location")
		checkPointManager.lastLocation = $RespawnPoint.global_position
