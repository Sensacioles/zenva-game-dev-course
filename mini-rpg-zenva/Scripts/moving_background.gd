extends TextureRect

@export var speed : float = 50 # Background movement speed
@export var extents : float = 1024 # Maximum pixels of movement 
@onready var start_pos : Vector2 = position # Initial position
@export var color_lerp : Gradient # Color changing gradient

# Move the background until reaching maximum extension
func _process(delta):
	position.x += speed * delta
	if position.x - start_pos.x >= extents:
		position = start_pos
	var time = sin(Time.get_unix_time_from_system())
	time = (time + 1) / 2
	modulate = color_lerp.sample(time)
