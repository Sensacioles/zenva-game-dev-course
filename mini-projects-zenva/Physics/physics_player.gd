extends RigidBody2D

var hit_force:float = 50.0


func _process(delta: float) -> void:
	# Check if left mouse button is clicked
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# Get mouse position
		var mouse_pos = get_global_mouse_position()
		
		# Check for mouse direction
		var dir = global_position.direction_to(get_global_mouse_position())
		
		# Apply the hit_force variable
		apply_impulse(dir*hit_force)
