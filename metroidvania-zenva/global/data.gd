extends Node

enum Gun {SINGLE, SHOTGUN, ROCKET} # Enumerate each weapon type
enum Level {SUBWAY, ROOFTOP, SEWER} # Enumerate each level
enum Enemy {DRONE, SOLDIER} # Enumerate each enemy type

# Set a dictionary with each scene path
const LEVEL_PATHS = {
	Level.SUBWAY: "res://scenes/levels/subway.tscn",
	Level.SEWER: "res://scenes/levels/sewer.tscn",
	Level.ROOFTOP: "res://scenes/levels/rooftop.tscn"
}

var current_level:Level = Level.SUBWAY # Set default current stage
var player_health:int = 5 # Store player health
var enemy_data:Dictionary
