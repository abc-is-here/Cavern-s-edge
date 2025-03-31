extends Area2D

var checkPointManager
var activated = false

func _ready() -> void:
	checkPointManager = get_parent().get_parent().get_node("CheckPointManager")


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !activated:
		activated = true
		$AnimationPlayer.play("CheckPointReached")
		checkPointManager.lastLocation = $RespawnPoint.global_position
