extends Tower

# Show crosshair sprite when called
func show_crosshair():
	$CrosshairSprite.show()

# Update crosshair sprite according to mouse position
func crosshair_pos_update(pos: Vector2i):
	$CrosshairSprite.global_position = pos

# Hide crosshair after placing tower
func finish_placing():
	$CrosshairSprite.hide()

# Shoot at crosshair position
func _on_reload_timer_timeout() -> void:
	$ShootAnimation.show()
	$ShootAnimation.play()
	await $ShootAnimation.animation_finished
	shoot.emit($CrosshairSprite.global_position,0,bullet_type)
	$ShootSound.play() # Play shot audio

# Update texture when upgrading tower
func tower_upgrade():
	$Base.texture = load("res://graphics/towers/mortar/mortar tower upgrade down.png")
