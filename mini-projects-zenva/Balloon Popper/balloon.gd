extends Area3D

@export var clicks_to_pop:int = 5
@export var size_increase:float = 0.2
@export var score_to_give:int = 1

var manager

func _ready() -> void:
	manager = $".."
	
func _on_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int) -> void:
	# Check if event is a mouse button event
	if event is not InputEventMouseButton:
		return
	# Check if left mouse button was clicked
	if event.button_index != MOUSE_BUTTON_LEFT:
		return
	# Check if event is a press event
	if not event.pressed:
		return
		
# Increases balloon size as it is clicked		
	scale += Vector3.ONE * size_increase
	clicks_to_pop -= 1
	
	if clicks_to_pop == 0:
		manager.increase_score(score_to_give)
		queue_free()
