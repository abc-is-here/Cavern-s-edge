extends Node

var lastLocation
var Player

func _ready() -> void:
	Player = get_parent().get_node("Player")
	lastLocation = Player.global_position
