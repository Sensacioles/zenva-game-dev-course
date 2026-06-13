extends CharacterBody2D

var direction:Vector2 # Drone direction coordinates
var speed := 50 # Drone speed
var player:CharacterBody2D # Store player reference
var spawn_point:Marker2D # Get enemy spawn point
# Update health value and free drone entity
var health := 3:
	set (value):
		health = value
		if health <= 0:
			explode.emit(position)
			spawn_point.defeated = true # Set enemy defeated value to true
			queue_free()
signal explode(pos:Vector2) 

# Detect when player enter drone's body
func _on_player_detection_area_body_entered(body: Node2D) -> void:
	player = body

# Detect when player exit drone's body
func _on_player_detection_area_body_exited(body: Node2D) -> void:
	player = null

# If player is detected, move towards it
func _physics_process(delta: float) -> void:
	if player:
		var dir = (player.position - position).normalized()
		velocity = dir * speed
		move_and_slide()

# Detect hit, subtract health and change shader parameter to simulate flashing animation
func hit():
	health -= 1
	$AudioStreamPlayer2D.play()
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D.material,'shader_parameter/Progress',1.0,0.3)
	tween.tween_property($AnimatedSprite2D.material,'shader_parameter/Progress',0.0,0.5)

# Explode on contact with player
func _on_area_2d_body_entered(body: Node2D) -> void:
	explode.emit(position)
	spawn_point.defeated = true # Set enemy defeated value to true
	queue_free()

# Set spawn position
func setup(new_spawn_point:Marker2D):
	position = new_spawn_point.global_position
	spawn_point = new_spawn_point
