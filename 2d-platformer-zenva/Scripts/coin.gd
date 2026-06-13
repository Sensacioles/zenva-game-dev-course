extends Area2D

var rotate_speed : float = 3.0 # Speed the sprite rotates
var bob_height : float = 5.0 # Maximum height the sprite "floats"
var bob_speed : float = 5.0 # Speed at which the sprite "floats"

@onready var start_pos : Vector2 = global_position # Sprite's initial position 
@onready var sprite : Sprite2D = $Sprite # Reference the sprite

func _physics_process(delta):
	var time = Time.get_unix_time_from_system()
	# Rotate the sprite using a sine wive
	sprite.scale.x = sin(time * rotate_speed)

	# Bobbing (floating) sprite animation using a sine wave as well
	var y_pos = ((1 + sin(time * bob_speed)) / 2) * bob_height
	global_position.y = start_pos.y - y_pos

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	body.increase_score(1)
	queue_free()
