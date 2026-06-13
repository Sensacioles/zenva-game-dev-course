extends Node2D

var parallax : float = 0.7 # Rate at which the background will follow Player
@onready var player = $"../Player" # Reference Player

func _process (delta):
	# Updates background position based on Player position and parallax value
	global_position = player.global_position * parallax 
