extends Control

var cost:int = 100 # Cost placeholder value
signal upgrade_press # Custom upgrade signal
signal delete_press # Custom delete button signal

# Emit signal if button is pressed
func _on_button_pressed() -> void:
	upgrade_press.emit()

func _on_delete_button_press() -> void:
	delete_press.emit()

# Set text to "Upgrade (<cost value>)"
func _ready() -> void:
	toggle_active(Data.money)
	$UpgradeButton.text = 'Upgrade ('+str(cost)+')'

# Toggle visibility for the upgrade button if money is not enough
func toggle_active(money:int):
	$UpgradeButton.disabled = cost > money

# Hide button if tower is already upgraded
func reveal(upgraded:bool):
	show()
	if upgraded:
		$UpgradeButton.hide()
