extends Camera2D

var drag:bool # State if camera is being dragged
@export var acceleration:=0.4 # Camera's acceleration 

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == 3:
		drag = event.pressed
	if event is InputEventMouseMotion:
		if drag:
			position -= event.relative * acceleration
