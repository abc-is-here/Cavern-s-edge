extends Node2D

var current_song: String = ""

func _ready() -> void:
	Global.currentSong = "res://Assets/music/Arena1.wav"
	current_song = Global.currentSong

func _process(_delta: float) -> void:
	if Global.currentSong != current_song:
		current_song = Global.currentSong
		change_music(current_song)

func _on_music_finished() -> void:
	pass

func change_music(song_path: String) -> void:
	var new_song = load(song_path)
	if new_song:
		pass
		
