extends Node

var score:int = 6
func _ready() -> void:
	if score==10:
		print("Score is 10.")
	if score > 5:
		print("Score is greater than 5.")
	
	var a:int = 100
	var b:int = 50
	
	if a > b:
		print("A is greater than B.")
	elif a != b:
		print("A is not equal to B.")
	else:
		print("A is equal to B.")
	_game_over()
	
# Challenge: Create a 'game_over' boolean variable and check if the game is over
#            If so, print "Go to menu", otherwise, print "Keep playing"
func _game_over() -> void:
	var game_over:bool = false
	if game_over:
		print("Go to menu.")
	else:
		print("Keep playing.")
