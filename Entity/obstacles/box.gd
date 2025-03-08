extends RigidBody2D

#@export var push_force: float = 5.0  # Adjust push strength
#
#func _ready() -> void:
	#contact_monitor = true
	#max_contacts_reported = 5
#
#func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	#for body in get_colliding_bodies():
		#if body.is_in_group("Player"):  # Check if the player is touching
			#var direction = (global_position - body.global_position).normalized()
			#state.apply_force(-direction * push_force)  # Apply a force instead of impulse
