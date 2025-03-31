extends CharacterBody2D

@export var speed: float = 50
@export var phase_time: float = 5.0
@export var follow_time: float = 10.0

@onready var appear_bar: ProgressBar = $CanvasLayer/ProgressBar
@onready var appear_timer: Timer = $Timer
@onready var DeathCollider: CollisionShape2D = $DeadZone/CollisionShape2D


var target: CharacterBody2D = null
var is_following: bool = false

func _ready():
	await get_tree().process_frame
	target = get_tree().get_nodes_in_group("Player")[0]
	start_appearance_phase()

func _process(delta):
	if not is_following:
		if appear_bar.value < 100:
			appear_bar.value += (100 / phase_time) * delta

	if is_following and target:
		var direction = (target.global_position - global_position).normalized()
		position += direction * speed * delta

		if appear_bar.value > 0:
			appear_bar.value -= (100 / follow_time) * delta

	appear_bar.queue_redraw()

func start_appearance_phase():
	is_following = false
	visible = false
	DeathCollider.disabled = true
	appear_timer.wait_time = phase_time
	appear_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1.0)
	tween.tween_callback(hide)

func start_following_phase():
	is_following = true
	visible = true
	DeathCollider.disabled = false
	appear_timer.wait_time = follow_time
	appear_timer.start()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0)

func _on_timer_timeout():
	if is_following:
		start_appearance_phase()
	else:
		start_following_phase()
