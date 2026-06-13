extends Area2D

@export var scene_to_load : PackedScene

func _load_new_scene ():
	get_tree().change_scene_to_packed(scene_to_load)

func _on_body_entered(body):
	if not body.is_in_group("Player"):
		return
	# Change scene if Player hits EndFlag
	call_deferred("_load_new_scene")
