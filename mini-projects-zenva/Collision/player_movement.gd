extends RigidBody3D

@export var move_speed:float = 2.0

func _physics_process(delta: float) -> void:
	if Input.is_physical_key_pressed(KEY_LEFT):
		apply_force(Vector3.LEFT*move_speed)
	if Input.is_physical_key_pressed(KEY_RIGHT):
		apply_force(Vector3.RIGHT*move_speed)


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Tree"):
		get_tree().reload_current_scene.call_deferred()
