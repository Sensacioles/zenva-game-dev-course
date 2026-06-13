extends ProgressBar

@onready var health_text : Label = $HealthText # Reference text inside health bar

func _ready ():
	var char = get_parent() # Store parent node
	max_value = char.max_health # Store max health value
	_update_value(char.current_health) # Update health value to its current value

	char.OnTakeDamage.connect(_update_value) # Signal if damage is taken
	char.OnHeal.connect(_update_value) # Signal if heal is cast

func _update_value (health : int):
	value = health # Assign health value to progress bar value 
	health_text.text = str(health) + " / " + str(int(max_value)) # Display current
