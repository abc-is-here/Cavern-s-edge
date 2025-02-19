@tool
class_name moving_plats
extends Path2D

@onready var path_follow: PathFollow2D = $PathFollow2D
@onready var remote_transform: RemoteTransform2D = $PathFollow2D/RemoteTransform2D
@onready var animatable_body: AnimatableBody2D = $AnimatableBody2D
@onready var sprite: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var collision: CollisionShape2D = $AnimatableBody2D/CollisionShape2D

@export var plat_tex: Texture2D
@export var scale_width: float = 1.0
@export var scale_height: float = 1.0

@export var speed = 25
var path_progress = 0

func _ready() -> void:
	sprite.texture = plat_tex
	sprite.scale = Vector2(scale_width, scale_height)
	path_follow.progress = 0
	path_progress = 0
	
	resize_collision_to_sprite()

func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		path_progress += speed*delta
		path_follow.set_progress(path_progress)

func resize_collision_to_sprite():
	if sprite.texture:
		var _sprite_size = sprite.get_rect().size * sprite.scale
		if collision.shape is RectangleShape2D:
			collision.shape.extents = _sprite_size/2
		elif collision.shape is CircleShape2D:
			collision.shape.radius = max(_sprite_size.x, _sprite_size.y)/2
		else:
			print("unsupported colision")
	else:
		print("no texture :(")
