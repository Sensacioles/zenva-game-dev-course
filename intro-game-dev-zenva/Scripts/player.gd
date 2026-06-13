extends CharacterBody2D


var speed:float = 100.0
#const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Reset velocity at start of every frame so the player doesn't stack 
	# its speed indefinetely 
	velocity.x = 0
	velocity.y = 0
	
	# Handle arrow key input
	if Input.is_key_pressed(KEY_RIGHT):
		velocity.x += speed
	if Input.is_key_pressed(KEY_LEFT):
		velocity.x -= speed
	if Input.is_key_pressed(KEY_UP):
		velocity.y -= speed
	if Input.is_key_pressed(KEY_DOWN):
		velocity.y += speed
	
	# Apply current velocity to move player
	move_and_slide()
