extends CharacterBody2D

@export var speed: float = 50.0
@export var player: CharacterBody2D
@export var chase_speed: float = 150.0
@export var charge_speed: float = 150.0
@export var acc: int = 300

@onready var sprite: Sprite2D = $Sprite2D
@onready var raycast: RayCast2D = $Sprite2D/RayCast2D2
@onready var charge_timer: Timer = $ChargeTimer

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2(1, 0)
var charging_direction: Vector2 = Vector2.ZERO
var right_bound: Vector2
var left_bound: Vector2

enum States {
	Wander,
	Chase,
	Charging
}
var cur_state = States.Wander

func _ready() -> void:
	left_bound = position + Vector2(-125, 0)
	right_bound = position + Vector2(125, 0)

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_movement(delta)
	change_direction()
	look_for_player()

func look_for_player():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider == player and cur_state == States.Wander:
			start_charge()

func start_charge():
	cur_state = States.Charging
	charging_direction = direction

	await get_tree().create_timer(0.2).timeout
	cur_state = States.Chase

	charge_timer.start(4.0)

func handle_movement(delta):
	if cur_state == States.Wander:
		velocity = velocity.move_toward(direction * speed, acc * delta)
	elif cur_state == States.Charging:
		velocity = velocity.move_toward(charging_direction * speed, acc * delta)
	elif cur_state == States.Chase:
		velocity = velocity.move_toward(direction * charge_speed, acc * delta)

	move_and_slide()

func change_direction():
	if cur_state == States.Wander:
		if direction.x == 1 and position.x >= right_bound.x:
			flip_direction()
		elif direction.x == -1 and position.x <= left_bound.x:
			flip_direction()
	elif cur_state == States.Chase:
		var target_dir = (player.position - position).normalized()
		direction.x = sign(target_dir.x)
		sprite.flip_h = direction.x == 1
		raycast.target_position.x = 125 if sprite.flip_h else -125

func flip_direction():
	direction.x *= -1
	sprite.flip_h = direction.x == 1
	raycast.target_position.x *= -1

func handle_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func _on_charge_timer_timeout() -> void:
	cur_state = States.Wander
