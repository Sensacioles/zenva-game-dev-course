extends Node2D

# Operators.
var score:int = 0
func _ready() -> void:
	score = 10    # Assign 10 to score
	score += 1    # Increment score by 1
	score -= 5    # Subtract score by 5
	score *= 2    # Multiply score by 2
	score /= 4    # Divide score by 4
	print(score)
	_money()

# Challenge: Start a 'money' variable on 10, add 5, double it, subtract by 3 and
#            divide by 2
func _money() -> void:
	var money:int = 10
	money+=5
	money*=2
	money-=3
	money/=2
	print(money)
