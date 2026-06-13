extends Area2D
@export var target:Data.Level # Export selectable target level to inspector

# Checks if player collides with transition gate. If so, call transition() between the target
# scene (set in the inspector) and the current level.
func _on_body_entered(player:CharacterBody2D) -> void:
	player.freeze()
	TransitionLayer.transition(target, Data.current_level)
