extends Area2D

@export var move_direction : Vector2 # Define a "path" for enemy movement
@export var move_speed : float = 20 # Velocity at which enemy moves

@onready var start_pos : Vector2 = global_position
@onready var target_pos : Vector2 = global_position + move_direction

func _physics_process(delta):
	# Set position by incrementing delta (physics tick) value multiplied by mov. speed
	global_position = global_position.move_toward(target_pos, move_speed * delta)
	
	# Check if target position is reached
	if global_position == target_pos:
		# Check if the current target position is its start. If it is, add 
		# move_direction to the start position to, essentially, continue its path.
		if target_pos == start_pos:
			target_pos = start_pos + move_direction
		# Otherwise, assign the target position to its start to "reset" the path.
		else:
			target_pos = start_pos

# Check if Player touches Enemy's body
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.take_damage(1)
	
# Play fly animation
func _ready():
	$AnimationPlayer.play("fly")
