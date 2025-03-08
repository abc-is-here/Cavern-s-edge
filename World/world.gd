extends Node2D

var current_song: String = ""  # Stores the currently playing song

func _ready() -> void:
	Global.currentSong = "res://Assets/music/Arena1.wav"
	current_song = Global.currentSong
	$AudioStreamPlayer.stream = load(current_song)
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.connect("finished", _on_music_finished)

func _process(_delta: float) -> void:
	if Global.currentSong != current_song:
		current_song = Global.currentSong
		change_music(current_song)

func _on_music_finished() -> void:
	$AudioStreamPlayer.play()

func change_music(song_path: String) -> void:
	var new_song = load(song_path)
	if new_song:
		$AudioStreamPlayer.stream = new_song
		$AudioStreamPlayer.play()
