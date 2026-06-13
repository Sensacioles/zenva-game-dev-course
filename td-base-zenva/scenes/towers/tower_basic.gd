extends Tower

var sprite_dir_offset := 16 # Direction offset based on sprite size

# Check if enemy array is not empty and set turret direction to its first element  
func _process(_delta: float) -> void:
	if enemies.size() > 0:
		$Turret.look_at(enemies[0].global_position)
		$Turret.rotation -= PI/2 # Correct rotation offset by 90 degrees

# Emit shoot signal on ReloadTimer timeout
func _on_reload_timer_timeout() -> void:
	if enemies:
		var dir = Vector2.DOWN.rotated($Turret.rotation).normalized()
		shoot.emit(position + dir * sprite_dir_offset, $Turret.rotation, Data.Bullet.SINGLE)
