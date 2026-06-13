class_name Tower extends Node2D # Define Tower class

var enemies:Array # Store enemies currently in range
@warning_ignore("unused_signal") # Ignore shooting signal for the parent class
signal shoot(pos:Vector2, directio:float, bullet_enum:Data.Bullet) # Signals shots for child scenes
# Check if enemy enters detection area and add it from enemy array
func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies:
		enemies.append(area)

# Check if enemy exits detection area and remove it from enemy array
func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if area in enemies:
		enemies.erase(area)

func _process(delta: float) -> void:
	print(enemies)
