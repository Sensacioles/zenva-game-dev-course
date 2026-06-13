extends CharacterBody2D

@export var move_speed : float = 100 # Maximum speed 
@export var acceleration : float = 50 # Rate which the player accelerates 
@export var braking : float = 20 # Rate which the player slows down
@export var gravity : float = 500 # Force of gravity applied to the player
@export var jump_force : float = 200 # Impulse velocity to the player's jump
@onready var sprite:Sprite2D = $Sprite # Reference to the sprite
@onready var anim:AnimationPlayer = $AnimationPlayer # Reference the animation player
@export var health:int = 3 # Define health "hits"
var move_input : float # Store player input
signal OnUpdateHealth (health : int)
signal OnUpdateScore (score : int)
@onready var audio : AudioStreamPlayer = $AudioStreamPlayer # Reference audio player
# Pre-load sfx
var take_damage_sfx : AudioStream = preload("res://Audio/take_damage.wav")
var coin_sfx : AudioStream = preload("res://Audio/coin.wav")

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity.y += gravity*delta
	
	# Get move_input. get_axis() returns -1 if "move_left" is pressed and 1
	# if "move_right" is pressed. If no key is pressed, return 0.
	move_input = Input.get_axis("move_left", "move_right")

	# Input multiplied by mov. speed = Velocity on the x axis. 
	# L inear interpolation (lerp method) added to smooth the movement.
	if move_input != 0:
		velocity.x = lerp(velocity.x, move_input * move_speed, acceleration * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, braking * delta)
	
	# Jumping: Check if jump key is pressed and if the character is on the ground.
	# If both are true, modify the velocity downwards on the y axis (only in 2D)
	# by setting the velocity to a negative jump_force value. 
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = -jump_force
	
	move_and_slide()

func _process(delta):
	# Game over if Player's position falls too much
	if global_position.y > 200:
		game_over()
	# Change sprite direction based on Player's movement
	if velocity.x != 0:
		sprite.flip_h = velocity.x > 0
	_manage_animation()

# Manage player's animation
func _manage_animation():
	if not is_on_floor():
		anim.play("jump")
	elif move_input != 0:
		anim.play("move")
	else:
		anim.play("idle")

# Decreases health at each hit taken
func take_damage(amount : int):
	health -= amount
	OnUpdateHealth.emit(health)
	_damage_flash()
	play_sound(take_damage_sfx)
	if health <= 0:
		call_deferred("game_over")

# Resets scene
func game_over():
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")

# Increase score when coin is collected
func increase_score(amount:int):
	PlayerStats.score += amount
	OnUpdateScore.emit(PlayerStats.score)
	play_sound(coin_sfx)

# Visual feedback for when Player takes damage
func _damage_flash():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.05).timeout
	sprite.modulate = Color.WHITE

# Play sound effect when function is called
func play_sound(sound : AudioStream):
	audio.stream = sound
	audio.play()
