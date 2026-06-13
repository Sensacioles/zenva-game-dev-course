extends Panel

@onready var button_container = $ButtonContainer # Reference ButtonContainer child node
var ca_buttons : Array[CombatActionButton]

@onready var description_text : RichTextLabel = $Description # Reference Description child node
@onready var game_manager = $"../.." # Reference game manager path

func _ready():
	# Loop through all child nodes inside button container and check if it doesn't
	# have a script assigned to it. Otherwise, append it to the action button array.
	for child in button_container.get_children():
		if child is not CombatActionButton:
			continue
		ca_buttons.append(child)
		child.pressed.connect(_button_pressed.bind(child))
		child.mouse_entered.connect(_button_entered.bind(child))
		child.mouse_exited.connect(_button_exited.bind(child))

# Loop through the button list and assign an action to i-th button and turn it visible.
# Hide any extra buttons if the action list is too short. 
func set_combat_actions(actions: Array[CombatAction]):
	for i in len(ca_buttons):
		if i >= len(actions):
			ca_buttons[i].visible = false
			continue

		ca_buttons[i].visible = true
		ca_buttons[i].set_combat_action(actions[i])

# Cast the action assigned to the button pressed
func _button_pressed(button: CombatActionButton):
	game_manager.player_cast_combat_action(button.combat_action)

# Display description assigned to each button
func _button_entered(button: CombatActionButton):
	var ca = button.combat_action
	description_text.text = "[b]" + ca.display_name + "[/b]\n" + ca.description

# Clear text if button isn't selected anymore
func _button_exited(button: CombatActionButton):
	description_text.text = ""

# Skip turn
func _on_pass_turn_button_pressed():
	game_manager.next_turn()
