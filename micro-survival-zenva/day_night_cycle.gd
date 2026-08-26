extends Node3D

var time:float
var time_rate:float
var sun:DirectionalLight3D
var moon:DirectionalLight3D
var environment:WorldEnvironment

@export var day_length:float = 20.0
@export var start_time : float = 0.3
@export var sun_color : Gradient
@export var sun_intensity : Curve
@export var moon_color : Gradient
@export var moon_intensity : Curve
@export var sky_top_color : Gradient
@export var sky_horizon_color : Gradient

func _ready():
	time_rate = 1.0 / day_length
	time = start_time
	sun = get_node("Sun")
	moon = get_node("Moon")
	environment = get_node("WorldEnvironment")

func _process(delta):
	time += time_rate * delta # Increase time by time rate per second
	# Reset time if it overflow 
	if time >= 1.0:
		time = 0.0
	# Change sun's rotation based on time "angle" + offset angle to hide 
	# the sun below the ground during sunrise/sunset
	sun.rotation_degrees.x = time * 360 + 90
	sun.light_color = sun_color.sample(time)
	# Change moon's rotation based on time "angle" + offset angle to hide 
	# the moon below the ground, in the opposite direction of the sun
	moon.rotation_degrees.x = time * 360 + 270
	moon.light_color = moon_color.sample(time)
	moon.light_energy = moon_intensity.sample(time)
	# Check which energy value is greater than 0, then display its node in the sky
	sun.visible = sun.light_energy > 0
	moon.visible = moon.light_energy > 0
	# Set sky's color based on current time
	environment.environment.sky.sky_material.set("sky_top_color", sky_top_color.sample(time))
	environment.environment.sky.sky_material.set("sky_horizon_color", sky_horizon_color.sample(time))
	# Set ground's color based on current time
	environment.environment.sky.sky_material.set("ground_bottom_color", sky_top_color.sample(time))
	environment.environment.sky.sky_material.set("ground_horizon_color", sky_horizon_color.sample(time))
