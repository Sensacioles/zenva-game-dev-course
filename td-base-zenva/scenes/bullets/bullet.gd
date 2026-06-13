extends Area2D

var direction:Vector2 # Bullet direction
var speed := 200 # Bullet speed

# Set up bullet position and angle. _bullet_enum is ignored
func setup(pos,angle,_bullet_enum):
	position = pos
	direction = Vector2.DOWN.rotated(angle)
	rotation = angle

func _process(delta: float) -> void:
	position += direction * speed * delta
