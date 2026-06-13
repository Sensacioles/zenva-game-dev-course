extends Sprite2D

# Sprite shake parameters
@onready var base_offset:Vector2 = offset
var shake_intensity:float = 0.0
var shake_damping:float = 10.0

# Sprite bobbing parameters 
var bob_amount:float = 0.02
var bob_speed:float = 7.0

# Communication with damage taken signal
func _ready() -> void:
	var character = get_parent()
	character.OnTakeDamage.connect(_damage_visual)

# Handling animations in real time
func _process(delta):
	# Bobbing animation using sine wave based formulas
	var t = Time.get_unix_time_from_system() # Get current time
	var y_scale = 1 + (sin(t * bob_speed) * bob_amount) # Scale of how much the sprite will float
	scale.y = y_scale # Apply the calculated scale to the sprite's vertical scale
	
	# Check if intensity is greater than 0. If so, lerpf() reduces it over time until reaching 0.
	# Set the sprite's offset to the value returned in _random_offset()
	if shake_intensity > 0:
		shake_intensity = lerpf(shake_intensity,0,shake_damping*delta)
		offset = base_offset + _random_offset()

# Flash the sprite in red if damage is taken
func _damage_visual(health:int):
	modulate = Color.RED
	shake_intensity = 10.0 # Add shake animation while taking damage
	await get_tree().create_timer(0.05).timeout
	modulate = Color.WHITE

# Calculate a random offset based on sprite shake intensity
func _random_offset() -> Vector2:
	var x = randf_range(-shake_intensity,shake_intensity)
	var y = randf_range(-shake_intensity,shake_intensity)
	return Vector2(x,y)
