extends Button

var id:Data.Tower = Data.Tower.BASIC # Tower distinct ID. BASIC is default.
var cost:int # Tower cost variable
signal press(tower_enum:Data.Tower)

# Get tower cost and call disable function
func _ready() -> void:
	cost = Data.TOWER_DATA[Data.Tower.BASIC]['cost']
	toggle_active(Data.money)

# Disable tower if not enough money is available
func toggle_active(money:int):
	disabled = cost > money
	
func _on_pressed() -> void:
	press.emit(id)
