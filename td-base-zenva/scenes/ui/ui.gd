extends CanvasLayer

signal place_tower(tower_type: Data.Tower) 
signal start_wave
enum MenuState {CLOSED, OPEN} # Track menu state
var current_state: MenuState = MenuState.CLOSED # Set closed menu to default 
var tower_card_scene = preload("res://scenes/ui/tower_card.tscn") # Load default tower card scene

# Set default texture to each menu button state
const MENU_BUTTON_TEXTURES = {
	MenuState.CLOSED: {
		'normal': "res://graphics/ui/menu.png",
		'pressed':"res://graphics/ui/menu.png",
		'hover': "res://graphics/ui/menu_hover.png"},
	MenuState.OPEN: {
		'normal': "res://graphics/ui/close_normal.png",
		'pressed': "res://graphics/ui/close_normal.png",
		'hover': "res://graphics/ui/close_hover.png"}}
# Connect tower card press method to a local function
func _ready() -> void:
	change_button_texture(current_state)
	$TowerCards/TowerCardsContainer.visible = current_state == MenuState.OPEN
	# For each card enum in the loop, instantiate the scene, set it up, add it as a child
	# of the card container and connect the press signal to the tower selector.
	for tower_enum in Data.Tower.values():
		var tower_card = tower_card_scene.instantiate()
		tower_card.setup(tower_enum)
		$TowerCards/TowerCardsContainer.add_child(tower_card)
		tower_card.connect('press',tower_select)

# Select the same tower type as the enum
func tower_select(tower_enum: Data.Tower):
	place_tower.emit(tower_enum)

# Update money interface
func update_stats(money: int, health:int):
	$Control/StatsContainer/PanelContainer2/TowerCardsContainer/Label.text = str(money)
	$Control/StatsContainer/PanelContainer/TowerCardsContainer/Label.text = str(health)

func _on_wave_button_pressed() -> void:
	start_wave.emit()

# Load the according button texture
func change_button_texture(state: MenuState):
	$TowerCards/MenuToggleButton.texture_normal = load(MENU_BUTTON_TEXTURES[state]['normal'])
	$TowerCards/MenuToggleButton.texture_hover = load(MENU_BUTTON_TEXTURES[state]['hover'])
	$TowerCards/MenuToggleButton.texture_pressed = load(MENU_BUTTON_TEXTURES[state]['pressed'])

# Change menu state if button is pressed
func _on_menu_toggle_button_pressed() -> void:
	current_state = MenuState.CLOSED if current_state == MenuState.OPEN else MenuState.OPEN
	change_button_texture(current_state)
	$TowerCards/TowerCardsContainer.visible = current_state == MenuState.OPEN

# Set card menu UI as collapsed by default
func hide_cards():
	current_state = MenuState.CLOSED
	change_button_texture(current_state)
	$TowerCards/TowerCardsContainer.visible = current_state == MenuState.OPEN
