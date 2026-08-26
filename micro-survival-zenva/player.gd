extends CharacterBody3D

var camera:Camera3D
var head:Node3D
var move_speed:float = 5.0
var jump_force:float = 5.0
var gravity:float = 9.0
var look_sens:float = 0.5
var min_x_rot : float = -85.0
var max_x_rot : float = 85.0
var mouse_dir : Vector2

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Hide cursor inside scene
	camera = get_node("Camera3D")
	head = get_node("Head")
	remove_child(camera)
	get_node("/root/Main").add_child.call_deferred(camera)

# Move camera
func _input(event):
	if event is InputEventMouseMotion:
		# Camera's axis are inverted, multiplying it by negative 'look_sens' reinverts it.
		# clamp() limits the camera rotation
		camera.rotation_degrees.x += event.relative.y * -look_sens # Vertical camera movement
		camera.rotation_degrees.y += event.relative.x * -look_sens # Horizontal camera movement
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, min_x_rot, max_x_rot)

func _process(delta):
	camera.position = head.global_position

# Handle player movement
func _physics_process(delta):
	# Control jump movement
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var dir = camera.basis.z * input.y + camera.basis.x * input.x
	# Remove camera slowdown if looking directly down or up
	dir.y = 0 
	dir = dir.normalized()
	velocity.x = dir.x * move_speed # Sideways movement
	velocity.z = dir.z * move_speed # Forward and backward movement
	move_and_slide() # Apply velocity and move player
