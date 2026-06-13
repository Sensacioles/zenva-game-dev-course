extends Area2D

var targets:Array

func setup(pos:Vector2):
	position = pos

# Add targets to the array when explosion makes contact with another entity
func _on_body_entered(body: Node2D) -> void:
	targets.append(body)

# Decrease health point to each target hit
func hurt_targets():
	for target in targets:
		target.hit()
