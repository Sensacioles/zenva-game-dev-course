class_name CombatAction
extends Resource

@export var display_name : String # Action name
@export var description : String # Action description

@export var melee_damage : int = 0 # Fixed melee damage value 
@export var heal_amount : int = 0 # Fixed healing value
@export var base_weight : int = 100 # Chance of NPC choosing certain action
