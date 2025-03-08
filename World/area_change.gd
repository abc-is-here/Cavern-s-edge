extends Node2D



func _on_arena_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.currentSong = "res://Assets/music/Arena1.wav"


func _on_arena_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.currentSong = "res://Assets/music/Arena2.wav"


func _on_arena_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.currentSong = "res://Assets/music/Arena3.wav"


func _on_arena_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.currentSong = "res://Assets/music/Arena4.wav"


func _on_boss_fight_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Global.currentSong = "res://Assets/music/BossFight.wav"
