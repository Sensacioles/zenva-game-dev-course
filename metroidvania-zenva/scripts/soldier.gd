extends CharacterBody2D

var direction:Vector2i = Vector2i.LEFT # Default movement direction
var player:CharacterBody2D # Store reference to player
var health := 2 # Default health value
var speed := 20 # Default speed value
var spawn_point:Marker2D

signal shoot(pos: Vector2, dir: Vector2, gun_type: Data.Gun)

# Process all actions and animations 
func _physics_process(delta: float) -> void:
	move()
	animation()

# Flip soldier sprite horizontally 
func animation():
	if health > 0:
		$Sprite2D.flip_h = direction.x < 0 
		# Set animation to running into current direction
		if direction:
			$AnimationPlayer.current_animation = 'run'
		# If player is detected, change animation to shooting based on the difference between player and
		# enemy position. 
		if player:
			var pos_difference = player.position - position
			$Sprite2D.flip_h = pos_difference.x < 0 
			$AnimationPlayer.current_animation = 'shoot_h' if pos_difference.y > -60 else 'shoot_up'
	else:
		$AnimationPlayer.current_animation = 'death'

# Update velocity and handle movement
func move():
	velocity = direction * speed * int(player is not CharacterBody2D) # If player is detected, halt movement
	move_and_slide()

# Signals if no floor is detected to left of soldier then flip direction to right
func _on_floor_left_area_body_exited(body: Node2D) -> void:
	direction = Vector2i.RIGHT

# Signals if no floor is detected to left of soldier then flip direction to left
func _on_floor_right_area_body_exited(body: Node2D) -> void:
	direction = Vector2i.LEFT

# Detect player collision with area radius and set it to the body
func _on_player_area_body_entered(body: Node2D) -> void:
	player = body
	$ShootTimer.start()

# Detect player exiting area radius and desassign it from body
func _on_player_area_body_exited(body: Node2D) -> void:
	player = null

# Decrease health if hit
func hit():
	health -= 1
	$AudioStreamPlayer2D.play()
	if health <= 0:
		player = null
		spawn_point.defeated = true
		$ShootTimer.stop()
	var tween = create_tween()
	tween.tween_property($Sprite2D.material, 'shader_parameter/Progress', 1.0, 0.3)
	tween.tween_property($Sprite2D.material, 'shader_parameter/Progress', 0.0, 0.5)

func stay_dead():
	$AnimationPlayer.active = false
	$Sprite2D.frame = 22
	direction = Vector2i.ZERO
	$CollisionShape2D.disabled = true


func _on_shoot_timer_timeout() -> void:
	if player:
		if player and health > 0:
			var dir = (player.position - position).normalized()
			shoot.emit(position + dir * 10, dir, Data.Gun.SINGLE)


func setup(new_spawn_point: Marker2D):
	position = new_spawn_point.global_position
	spawn_point = new_spawn_point
