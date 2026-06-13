extends Node2D

class_name Character # Setting up Character class

signal OnTakeDamage(health:int) # Custom signal on event of taking damage
signal OnHeal(health:int) # Custom signal on event of healing damage

@export var is_player:bool # Boolean to check if Character is the player or NPC
@export var current_health:int # Stores Character current health
@export var max_health:int # Stores Character max health
@export var combat_actions:Array[CombatAction]
var target_scale:float = 1.0  # Scale of Character sprite to indicate whose turn is up
@onready var audio:AudioStreamPlayer = $AudioStreamPlayer # Reference AudioStreamPlayer
var take_damage_sfx:AudioStream = preload("res://Audio/take_damage.wav") # Reference damage sfx
var heal_sfx:AudioStream = preload("res://Audio/heal.wav") # Reference heal sfx
@export var facing_left:bool = false # Set default sprite orientation
@export var display_texture:Texture2D # Create texture variable
@onready var sprite:Sprite2D = $Sprite # Reference Character sprite

# Add sprite orientation and texture parameters to the Inspector tab.
func _ready():
	sprite.flip_h = facing_left
	sprite.texture = display_texture
# Upscales Character to indicate turn start
func begin_turn():
	target_scale = 1.3

# Downscales Character to indicate turn end
func end_turn():
	target_scale = 1.0

# Apply current scale to Character sprite based on turn
func _process(delta):
	scale.x = lerp(scale.x, target_scale, delta * 10)
	scale.y = lerp(scale.y, target_scale, delta * 10)

# Subtract damage value from current health, updating health value and playing sfx
func take_damage(amount:int):
	current_health -= amount
	OnTakeDamage.emit(current_health)
	_play_audio(take_damage_sfx)

# Add heal value to current health, updating health value and playing sfx
func heal(amount:int):
	current_health += amount
	current_health = clamp(current_health,0,max_health) # Guarantee healing amount doesn't exceed max value
	OnHeal.emit(current_health)
	_play_audio(heal_sfx)

# Check which action is cast (damage or healing type) and update health value.
# Also check if action is null (pass). Return early if so.
func cast_combat_action(action:CombatAction,opponent):
	if action == null:
		return
	if action.melee_damage > 0:
		opponent.take_damage(action.melee_damage)
	if action.heal_amount > 0:
		heal(action.heal_amount)

# Play audio assigned to AudioStream
func _play_audio(stream:AudioStream):
	audio.stream = stream
	audio.play()
