extends Node2D

@onready var spikes: Node2D = $Spikes
var speed := 200
var rotation_speed := 2.0
var reset_time := 3.0
var original_states := {}

func _ready():
	for spike in spikes.get_children():
		original_states[spike] = {
			"position": spike.global_position,
			"rotation": spike.rotation
		}

func _process(delta):
	for spike in spikes.get_children():
		if spike is Sprite2D:
			spike.rotation += rotation_speed * delta
			var direction = Vector2.UP.rotated(spike.rotation)
			spike.global_position += direction * speed * delta

func reset_spikes():
	for spike in spikes.get_children():
		if spike in original_states:
			spike.global_position = original_states[spike]["position"]
			spike.rotation = original_states[spike]["rotation"]

func _on_timer_timeout() -> void:
	reset_spikes()
