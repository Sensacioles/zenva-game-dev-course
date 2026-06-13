extends CanvasLayer

# Update UI with current health
func set_health(health:int):
	$TextureProgressBar.value = health
