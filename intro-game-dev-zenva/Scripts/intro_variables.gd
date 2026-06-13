extends Node2D

# Variables 
var score:int = 5
var move_speed:float = 2.53
var game_over:bool = false
var ability:String = "Demon Fang"
func _ready() -> void:
	print(score)
	print(move_speed)
	print(game_over) 
	print(ability)
	print("\nChanging parameters...\n")
	score = 15
	move_speed = 4.5
	game_over = true
	print(score)
	print(move_speed)
	print(game_over) 
	print(ability)
	_country()

# Challenge: List a country's name, population, max altitude and if it is
#                  landlocked or not
var country_name:String = "Brasil"
var population:float = 213.4
var max_altitude:float = 2995.3
var landlocked:bool = false
func _country() -> void:
	print("\nCountry Stats: \n")
	print("Name: " + country_name)
	print("Population: " + str(population) + " millions")
	print("Highest altitude (m): " + str(max_altitude)) 
	if landlocked:
		print("Landlocked: Yes")
	else:
		print("Landlocked: No")
