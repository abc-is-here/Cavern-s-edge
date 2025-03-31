extends CharacterBody2D

const GRAVITY = 1600
var speed = 150.0
var direction = 1
var player_in_range: Node2D = null

enum States { Idle, Walk, Blast }
var cur_state = States.Walk

@onready var raycast_bottom: RayCast2D = $RayCast2D
@onready var raycast_wall: RayCast2D = $RayCast2D2
@onready var slime: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var blast_range: Area2D = $BlastRange
@onready var dead_zone: Area2D = $DeadZone
@onready var idle_timer: Timer = $IdleTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var blast_sprite: Sprite2D = $AnimatedSprite2D/blast

var checkPointManager
var Player
var start_position

func _ready() -> void:
	slime.play("walk")
	checkPointManager = get_tree().get_first_node_in_group("CheckPointManager")
	Player = get_tree().get_first_node_in_group("Player")
	start_position = global_position
	
	idle_timer.wait_time = randf_range(2, 5)
	idle_timer.start()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	match cur_state:
		States.Walk:
			handle_walk()
		States.Idle:
			velocity.x = 0
		States.Blast:
			velocity = Vector2.ZERO

	move_and_slide()

func handle_walk() -> void:
	if not raycast_bottom.is_colliding() or raycast_wall.is_colliding():
		change_direction()

	velocity.x = speed * direction

func change_direction() -> void:
	direction *= -1
	slime.flip_h = direction == -1
	raycast_bottom.position.x = 10 * direction
	raycast_wall.position.x = 10 * direction
	raycast_wall.target_position.x = 20 * direction

func _on_idle_timer_timeout() -> void:
	if cur_state != States.Walk:
		return
	
	cur_state = States.Idle
	slime.play("idle")

	await get_tree().create_timer(1).timeout

	cur_state = States.Walk
	slime.play("walk")

	idle_timer.wait_time = randf_range(2, 5)
	idle_timer.start()

func _on_blast_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and cur_state != States.Blast:
		start_blast(body)

func start_blast(body: Node2D) -> void:
	cur_state = States.Blast
	player_in_range = body
	velocity = Vector2.ZERO

	await get_tree().create_timer(1).timeout
	
	# Ensure blast animation plays correctly
	blast_sprite.visible = true
	animation_player.play("blast")

	await animation_player.animation_finished

	if player_in_range != null and !Global.is_immune:
		Global.emit_signal("shake_camera")
		KillPlayer()

	# Hide the enemy and disable collision
	visible = false
	collision.set_deferred("disabled", true)
	blast_range.monitoring = false
	dead_zone.monitoring = false

	await get_tree().create_timer(4).timeout

	reset_enemy()

func reset_enemy():
	position = start_position  
	visible = true
	collision.set_deferred("disabled", false)
	blast_range.monitoring = true
	dead_zone.monitoring = true
	cur_state = States.Walk
	slime.play("walk")
	player_in_range = null

func KillPlayer():
	if checkPointManager and checkPointManager.lastLocation:
		Player.global_position = checkPointManager.lastLocation

func _on_blast_range_body_exited(body: Node2D) -> void:
	if body == player_in_range:
		player_in_range = null
