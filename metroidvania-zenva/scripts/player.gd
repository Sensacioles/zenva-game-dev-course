extends CharacterBody2D

# Define starting health points and update UI elements whenever player is hit.
# Replaced with Data.player_health variable
"var health := 5: 
	set(value):
		health = value
		$UI.set_health(health)"
var direction_x:float # Horizontal input
var gravity = 200 # Gravity variable
var duck:bool # Duck state variable
var on_floor:bool # On air state
var controller_aim:bool # Detect controller input for aiming
var target_dir:Vector2 # Store last known aim direction
var current_gun:Data.Gun # Store current gun
var frozen:bool # Store scene transition freeze status 
 
# Group variables into movement category
@export_category('Movement') 
@export var speed := 150 # Export speed value
@export var acceleration := 600 # Export acceleration value
@export var friction := 800 # Export friction value
@export var dash_speed := 600 # Export dash speed

# Group variables into jump category
@export_category('Jump') 
@export var jump_height: float = 100 # Maximum jump height
@export var jump_time_to_peak: float = 0.5 # Time which player takes to reach jump peak
@export var jump_time_to_descent: float = 0.4 # Time which player takes to fall from jump peak

# Group variables into shooting category
@export_category('Shooting')
@export var crosshair_distance := 100 # Control crosshair offset from player
@export var shotgun_distance := 25 # Control shotgun shot animation offset from player

# Calcule jump velocity, its gravity and gravity applied to falling speed
@onready var jump_velocity: float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity: float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_descent)) * -1.0

signal shoot(pos: Vector2, dir: Vector2, gun_type:Data.Gun) # Signal the shot, its current position and direction

# Create constant vectors for all 9 directions of torso sprite
const GUN_DIRECTIONS = {
  Vector2i(0,0): 0, Vector2i(1,0): 0,
  Vector2i(1,1): 1, Vector2i(0,1): 2,
  Vector2i(-1,1): 3, Vector2i(-1,0): 4,
  Vector2i(-1,-1): 5, Vector2i(0,-1): 6,
  Vector2i(1,-1): 7,}

# Set health when node is started in a scene
func _ready() -> void:
	$UI.set_health(Data.player_health)

# Update crosshair on mouse position normalized to the crosshair_distance variable
func _process(_delta: float) -> void:
	$Sprites/Crosshair.update(get_aim_dir(), crosshair_distance, duck)
	if on_floor and not is_on_floor() and velocity.y >= 0:
		$Timer/CoyoteTimer.start()

# Process movement and animations
func _physics_process(delta: float) -> void:
	if not frozen:
		get_input()
		move(delta)
		animation()
		on_floor = is_on_floor()
		move_and_slide()

#
func _input(event:InputEvent) -> void:
	if Input.get_vector("aim_left","aim_right","aim_up","aim_down"):
		controller_aim = true
	if event is InputEventMouseMotion:
		controller_aim = false

# Read input actions mapped in the project settings. 
# If the action in get_axis() first parameter is pressed, the function return
# a negative value, else return positive.
func get_input():
	direction_x = Input.get_axis("left", "right")
	# Instantly set vertical velocity to a negative value to 
	# simulate jumping if jump button is pressed
	if Input.is_action_just_pressed("jump") and (is_on_floor() or $Timer/CoyoteTimer.time_left):
		velocity.y = jump_velocity
	# If shoot button is pressed and there isn't any time left in the reload timer,
	# emit a signal to the bullet from the current position towards the cursor direction and
	# start a new timer. 
	if Input.is_action_just_pressed("shoot") and not $Timer/ReloadTimer.time_left:
		shoot.emit(position, get_aim_dir(), current_gun)
		$Timer/ReloadTimer.start()
		if current_gun == Data.Gun.SHOTGUN:
			$ShotgunParticles.position = get_aim_dir() * shotgun_distance
			$ShotgunParticles.process_material.set('direction',get_aim_dir())
			$ShotgunParticles.emitting = true
	# If dash button is pressed and there isn't any time left in the dash timer,
	# increase player's use tween function to increase speed momentarily and simulate a dash movement.
	# Then, call _dash_finish function to control velocity at the end of dash.
	if Input.is_action_just_pressed("dash") and not $Timer/DashTimer.time_left:
		$Timer/DashTimer.start()
		var tween = create_tween()
		tween.tween_property(self,'velocity:x',velocity.x + direction_x * dash_speed,0.3)
		tween.tween_callback(_dash_finish)
	duck = Input.is_action_pressed("duck") and is_on_floor()
	# If toggle key is pressed, advance one integer on the Gun enum list.
	# Posmod ensures the list is reset to 0 whenever it reaches the end. It returns a plain integer,
	# so the "as" statement converts it to a proper Gun enum value.
	if Input.is_action_just_pressed("toggle"):
		current_gun = posmod(current_gun+1,Data.Gun.size() as Data.Gun)

# Check if controller is being used and update aim direction based on right analog stick input.
# The function only overwrites the aim direction if the right analog stick is moved, maintaining the
# current aim direction instead of it snapping to the center every time.
func get_aim_dir() -> Vector2:
	if controller_aim:
		var controller_aim_dir = Input.get_vector("aim_left","aim_right","aim_up","aim_down")
		# Analog sticks's vector is non-zero, so this detects any input.
		if controller_aim_dir.length():
			target_dir = controller_aim_dir.normalized()
		# Otherwise, just use mouse position to aim.
	else:
		target_dir = get_local_mouse_position().normalized()
	return target_dir

# Return correct gravity value based on player's vertical velocity
func get_custom_gravity() -> float:
	return jump_gravity if velocity.y < 0.0 else fall_gravity

# While the player provides horizontal input, move horizontal velocity to a target speed (direction_x * speed),
# when it stops, move velocity.x to 0 using friction value as a medium.
func move(delta):
	if not duck:
		if direction_x:
			velocity.x = move_toward(velocity.x,direction_x * speed,acceleration * delta)
		else:
			velocity.x = move_toward(velocity.x,0,friction * delta)
	else:
		velocity.x = move_toward(velocity.x,0,friction * delta * 2)
	if not is_on_floor():
		velocity.y += get_custom_gravity() * delta

# Handle player's sprite animation
func animation():
	# Check if horizontal direction isn't neutral and apply the current value (negative for left,
	# positive for right) to flip the sprite's orientation. If duck state is true, mantains value.
	# Check the same for the torso sprite.
	if direction_x != 0:
		$Sprites/LegSprite.flip_h = direction_x < 0
	if is_on_floor():
		$AnimationPlayer.current_animation = 'run' if direction_x else 'idle'
		$AnimationPlayer.current_animation = 'duck' if duck else $AnimationPlayer.current_animation
	else:
		$AnimationPlayer.current_animation = 'jump'
	var raw_dir = get_aim_dir()
	var adjusted_dir = Vector2i(round(raw_dir.x),round(raw_dir.y))
	$Sprites/TorsoSprite.frame = GUN_DIRECTIONS[adjusted_dir] + int(current_gun) * $Sprites/TorsoSprite.hframes
	$Sprites/TorsoSprite.position.y = 0 if duck else -8

# Decrease current health when taking a hit
func hit():
	Data.player_health -= 1
	$UI.set_health(Data.player_health)
	$AudioStreamPlayer2D.play()

# Quickly reduce velocity to add control to the dash
func _dash_finish():
	velocity.x = move_toward(velocity.x, 0, 500)

func freeze():
	frozen = true
	$AnimationPlayer.pause()
