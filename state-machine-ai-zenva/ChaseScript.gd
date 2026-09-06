extends State

@export var flee_range:float = 1.0
@export var lose_interest_range:float = 10.0

var path_update_rate : float = 0.1
var last_path_update_time : float

# Override enter method
func enter():
	super.enter()
	controller.is_running = true # Set to run after player
	controller.look_at_player = true

func exit():
	super.exit()
	controller.is_running = false # Stop chasing player
	controller.look_at_player = false
# Calculate a new random wander position

func update(delta):
	var current_time = Time.get_unix_time_from_system() # Get current time increasing by 1 for every second
	# Update path and to move to new position
	if current_time - last_path_update_time > path_update_rate:
		last_path_update_time = current_time
		controller.move_to_position(controller.player.position,false)
	# Change state if player is too close or too far 
	if controller.player_distance < flee_range:
		state_machine.change_state("Flee")
	if controller.player_distance > lose_interest_range:
		state_machine.change_state("Wander")
