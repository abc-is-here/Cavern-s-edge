extends Area2D

@onready var Collider: CollisionShape2D = $Collider
@onready var Sprite: Sprite2D = $Sprite
@onready var Animator: AnimationPlayer = $Animator

@export_category("Bounce Properties")
@export var bounceAmount: float = 1.5

func _ready() -> void:
	Animator.play("Normal")

func _on_body_entered(body: Node2D) -> void:
	if (body is PlayerController):
		if (Animator.current_animation == "Normal"):
			Animator.play("Launch")
			body.velocity.y = body.JumpVelocity * bounceAmount


func _on_animator_animation_finished(anim_name: StringName) -> void:
	if (anim_name == "Launch"):
		Animator.play("Recoil")
	if (anim_name == "Recoil"):
		Animator.play("Normal")
