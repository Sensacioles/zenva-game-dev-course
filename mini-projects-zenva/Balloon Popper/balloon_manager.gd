extends Node3D

var score:int = 0
var score_text:Label
func increase_score(amount:int):
	score += amount
	score_text.text = "Score: " + str(score)

func _ready():	
	# $ScoreText references the label object in the 3D Node
	score_text = $ScoreText
	score_text.text = "Score: 0"
