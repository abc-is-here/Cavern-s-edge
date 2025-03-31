extends Node

signal shake_camera
signal DashFallBack
signal RockFall
var is_in_deadzone = false
var is_in_water = false
var is_immune = false
var currentSong
var is_dashing = false
var reflect = false
var player_in_bubble = false

func slow_time(duration: float, factor: float = 0.5):
	Engine.time_scale = factor
	await get_tree().create_timer(duration * factor).timeout
	Engine.time_scale = 1.0
