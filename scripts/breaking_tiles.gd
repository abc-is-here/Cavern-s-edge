@tool
class_name Breaking_platform
extends StaticBody2D

@onready var collision: CollisionShape2D = $collision
@onready var area: Area2D = $Area
@onready var detect: CollisionShape2D = $Area/detect

@export var width_scale: float = 1.0
@export var height_scale: float = 1.0
@export var one_way: bool = false

@export var platform_tex: Texture2D
@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var normal: String = "normal"
@export var breaking: String = "breaking"
@export var broken: String = "broken"

enum platform_state{
	normal,
	breaking,
	broken
}

var cur_state: platform_state = platform_state.normal
var height_area: int = 4

func _ready() -> void:
	sprite.texture = platform_tex
	sprite.scale = Vector2(width_scale, height_scale)
	collision.one_way_collision = one_way
	
	animation.animation_finished.connect(OnAnimationFinished)
	
	collision_resizer()
	area_resizer()

func OnAnimationFinished(cur_anim: String):
	if cur_anim == breaking:
		cur_state = platform_state.broken
	if cur_anim == broken:
		cur_state = platform_state.normal
	
func _process(delta: float) -> void:
	if !Engine.is_editor_hint():
		match cur_state:
			platform_state.breaking:
				animation.play(breaking)
			platform_state.broken:
				collision.disabled = true
				animation.play(broken)
			_:
				animation.play(normal)
				collision.disabled = false
		
		platform_trig_handler()
				

func collision_resizer():
	if sprite.texture:
		var _size_sprite = sprite.get_rect().size * sprite.scale
		
		if collision.shape is RectangleShape2D:
			collision.shape.extents = _size_sprite/2
		elif collision.shape is CircleShape2D:
			collision.shape.radius = max(_size_sprite.x, _size_sprite.y)/2
		else:
			pass
	else:
		pass
		
func area_resizer():
	if sprite.texture:
		var _size_sprite = sprite.get_rect().size * sprite.scale
		
		if collision.shape is RectangleShape2D:
			detect.shape.extents = Vector2(_size_sprite.x/2, height_area)
			detect.position = detect.position - Vector2(0, collision.shape.extents.y)
		elif collision.shape is CircleShape2D:
			collision.shape.radius = max(_size_sprite.x, _size_sprite.y)/2
		else:
			pass
	else:
		pass

func platform_trig_handler():
	var _bodies = area.get_overlapping_bodies()
	for i in _bodies:
		if i is CharacterBody2D and i.is_on_floor():
			if cur_state == platform_state.normal:
				cur_state = platform_state.breaking
