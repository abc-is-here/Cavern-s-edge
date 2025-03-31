extends Control

@onready var Name: Sprite2D = $Name
@onready var play: TextureButton = $Play
@onready var settings: TextureButton = $Settings
@onready var quit: TextureButton = $Quit

var time: float = 0.0
var amplitude: float = 10.0
var frequency: float = 2.0
var original_y: float

func _ready():
	original_y = Name.position.y

func _process(delta):
	time += delta
	var sine_offset = sin(time * frequency) * amplitude
	Name.position.y = original_y + sine_offset

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://World/World.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
