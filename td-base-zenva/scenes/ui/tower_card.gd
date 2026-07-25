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

# Set up a new card
func setup(new_id: Data.Tower):
	id = new_id
	$Panel/VBoxContainer/Control/VBoxContainer/Label.text = Data.TOWER_DATA[id]['name']
	$Panel/VBoxContainer/Control/VBoxContainer/Label2.text = str(Data.TOWER_DATA[id]['cost'])
	$Panel/VBoxContainer/TowerPreview/TextureRect.texture = load(Data.TOWER_DATA[id]['thumbnail'])
