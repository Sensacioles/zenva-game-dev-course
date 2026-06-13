extends CanvasLayer

# Modulate alpha value to zero on the start of every scene
func _ready() -> void:
	$ColorRect.modulate.a = 0.0

# Control alpha (opacity) on transition layer so it appears as a fade in and out animation 
func transition(target_level:Data.Level, current_level:Data.Level):
	var tween = create_tween()
	tween.tween_property($ColorRect, "modulate:a", 1.0, 0.8)
	tween.tween_interval(0.5) # Set a pause to bind the current scene to the next
	tween.tween_callback(_change_scene.bind(target_level,current_level))
	tween.tween_property($ColorRect, "modulate:a", 0.0, 0.8)

# Removes current scene from tree, load and instantiate the next one. Then, point the next scene to
# the current_level parameter.
func _change_scene(target_level:Data.Level, current_level:Data.Level):
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	var scene = load(Data.LEVEL_PATHS[target_level]).instantiate()
	get_tree().root.add_child(scene) # Load next scene
	get_tree().current_scene = scene # Set next scene to be the current
	scene.position_player(current_level)
	Data.current_level = target_level # Change current level
