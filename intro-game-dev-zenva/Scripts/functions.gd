extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Ready")
	_welcome_message()
	_add_with_params(1,2)
	print(_has_won(50))
	print(_has_won(101))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	print("Process")

# Note: By convention, private functions (that are only ran inside their own 
#		script) start with a underscore, while public ones don't.
func _welcome_message() -> void:
	print("Welcome to the game!")

func _add_with_params(a:int,b:int) -> int:
	return a+b

# Challenge: Create a '_has_won' function that returns true or false whether
#            a 'score' parameter is above 100.
func _has_won(score:int) -> bool:
	if score>100:
		return true
	else:
		return false
