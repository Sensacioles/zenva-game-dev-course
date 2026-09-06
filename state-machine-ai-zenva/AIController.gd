class_name AIController
extends CharacterBody3D

@export var walk_speed:float = 1.0
@export var run_speed:float = 2.5

@onready var agent:NavigationAgent3D = get_node("NavigationAgent3D")
@onready var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity") # Get default gravity value from project settings
@onready var player = get_tree().get_nodes_in_group("Player")[0] # Get first node in Player group list

var is_running:bool = false
var is_stopped:bool = false
var look_at_player:bool = true
var move_direction:Vector3
var target_y_rot:float
var player_distance:float

# Check if player exists and calculate distance to it
func _process(delta: float) -> void:
	if player != null:
		player_distance = position.distance_to(player.position)

# Handle AI orientation and path towards player
func _physics_process(delta):
	# Decrease vertical velocity to simulate gravity effect
	if not is_on_floor():
		velocity.y -= gravity*delta

	var target_pos = agent.get_next_path_position() # Find next target
	var move_dir = position.direction_to(target_pos) # Set normalized movement direction

	move_dir.y = 0 # Set y value to 0 so AI doesn't change its vertical direction without interacting with terrain
	
	# Check if path is finished or if AI is stopped, then halt its movement vector
	if agent.is_navigation_finished() or is_stopped:
		move_dir = Vector3.ZERO

	# Check if AI is set to run, change its horizontal and forward velocity based on current speed if so
	var current_speed = walk_speed

	if is_running:
		current_speed = run_speed
	velocity.x = move_dir.x * current_speed
	velocity.z = move_dir.z * current_speed

	move_and_slide()

	# Check for player next direction
	if look_at_player:
		var player_dir = player.position - position
		target_y_rot = atan2(player_dir.x,player_dir.z)
	elif velocity.length() > 0:
		target_y_rot = atan2(velocity.x,velocity.z)

	rotation.y = lerp_angle(rotation.y,target_y_rot,0.1)

# Handle movement to player
func move_to_position(to_position : Vector3, adjust_pos : bool = true):
	# Set new agent if not already set
	if not agent:
		agent = get_node("NavigationAgent3D")
	
	# Reset stop variable to ensure the agent is able to move
	is_stopped = false
	
	# Set agent position in the map and adjust position to the mapmesh if needed
	if adjust_pos:
		var map = get_world_3d().navigation_map
		var adjusted_pos = NavigationServer3D.map_get_closest_point(map,to_position)
		agent.target_position = adjusted_pos
	else:
		agent.target_position = to_position
