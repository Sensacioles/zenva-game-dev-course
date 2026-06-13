extends Node2D

@export var player_character:Character # Playable Character object
@export var ai_character:Character # NPC Character object
var current_character:Character # Current Character object
var game_over:bool = false # Current game state
@onready var player_ui = $CanvasLayer/CombatActionsUI # Action menu
@onready var end_screen = $CanvasLayer/EndScreen

func _ready():
	next_turn()
	player_character.OnTakeDamage.connect(_on_player_take_damage)
	ai_character.OnTakeDamage.connect(_on_ai_take_damage)
	end_screen.visible = false

func _on_player_take_damage (health:int):
	if health <= 0:
		end_game(ai_character)

func _on_ai_take_damage (health:int):
	if health <= 0:
		end_game(player_character)

func end_game(winner:Character):
	game_over = true
	end_screen.visible = true
	if winner == player_character:
		end_screen.set_header_text("You won! :D")
	else:
		end_screen.set_header_text("You lost... :(")

func next_turn():
	# Check if the game is over
	if game_over:
		return

	# Check if current character is assigned. If it is, end its turn.
	if current_character != null:
		current_character.end_turn()

	# Check if it's the NPC's or none's turn. Change to player's turn if so.
	# Otherwise, keep the NPC's turn.  
	if current_character == ai_character or current_character == null:
		current_character = player_character
	else:
		current_character = ai_character
	
	# Start current Character turn
	current_character.begin_turn()
	
	# Enable and set player UI
	if current_character.is_player:
		player_ui.visible = true
		player_ui.set_combat_actions(player_character.combat_actions)
	
	# Disable player UI if still active from the previous turn
	else:
		player_ui.visible = false
		var wait_time = randf_range(0.5, 1.5)
		await get_tree().create_timer(wait_time).timeout
		var action_to_cast = ai_decide_combat_action()
		ai_character.cast_combat_action(action_to_cast, player_character)
		await get_tree().create_timer(0.5).timeout
		next_turn()

func player_cast_combat_action(action:CombatAction):
	# Early check if the player is the current Character
	if player_character != current_character:
		return

	player_character.cast_combat_action(action, ai_character)
	player_ui.visible = false
	await get_tree().create_timer(0.5).timeout
	next_turn()
	
func ai_decide_combat_action() -> CombatAction:
	# Early return if current character isn't NPC
	if ai_character != current_character:
		return null
	var ai = ai_character # Store NPC Character reference
	var player = player_character # Store Playable Character reference
	var actions = ai.combat_actions # Store NPC combat actions
	var weights: Array[int] = [] # Create an array of weights
	var total_weight = 0 # Total weight for the actions
	# Calculate both NPC and Playable Characters health percentage
	var ai_health_perc = float(ai.current_health)/float(ai.max_health)
	var player_health_perc = float(player.current_health)/float(player.max_health)
	
	# Loop through action array and multiply weight by a factor that depends on
	# the current state of battle (advantage, danger, neutral, etc.)
	for action in actions:
		var weight:int = action.base_weight # Store base weight
		# If Playable Character's health is low, chance of dealing damage increases
		if player.current_health <= action.melee_damage:
			weight *= 3
		# If NPC Character's health is low, chance of casting heal increases
		if action.heal_amount > 0:
			weight *= 1 + (1 - ai_health_perc)
		weights.append(weight) # Add action weight to weigths array
		total_weight += weight # Increment total weight by weight of current action
	
	var cumulative_weight = 0 # Cumulative weight that will store each of the action array's weights
	var rand_weight = randi_range(0,total_weight) # Random weight from 0 to calculated total weight 
	
	# Create a loop until NPC's action list size end and increment current weight to
	# a cumulative weight. If the random weight is smaller than the cumulative weight
	# value, return the current action in the list. 
	for i in len(actions):
		cumulative_weight += weights[i]
		if rand_weight < cumulative_weight:
			return actions[i]
	
	return null
