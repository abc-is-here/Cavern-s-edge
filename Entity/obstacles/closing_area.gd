extends Area2D

@onready var anim_player = $"../AnimationPlayer"

func _on_body_entered(body):
	if body.is_in_group("Player"):
		anim_player.play("Open_Walls")

		await anim_player.animation_finished
		anim_player.play("Close_Walls")

		await anim_player.animation_finished
