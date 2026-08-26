extends ProgressBar

@export var need_name:String
@onready var text:Label = get_node("NeedText") # Assign label text based on node's label

# Set max health value and update it 
func update_value (new_value, max):
	max_value = max
	value = new_value
	text.text = str(need_name, " ", int(value), "/", int(max_value)) # Update label text
