extends Area2D

var direction: Vector2 # 2x2 vector indicating the bullet direction final coordinates
var speed: int = 200 # Bullet's speed
var type: Data.Gun # Enum Gun type
const OFFSET = 16 # Add an offset to spawn the bullet 16 pixels away from the sprite
# Apply bullet texture based on type
const TEXTURE = {
	Data.Gun.SINGLE: preload("res://graphics/fire/default.png"),
	Data.Gun.ROCKET: preload("res://graphics/fire/large.png"),
}
# Detect collision to play explosion animation
signal explode(pos:Vector2)

# Continue to move bullet to a set direction
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

# Set up a new bullet, considering a offset value
func setup(pos: Vector2, dir: Vector2, gun_type:Data.Gun):
	position = pos + dir * OFFSET
	direction = dir
	type = gun_type
	$Sprite2D.texture = TEXTURE[gun_type]

# Detect when bullet hit a external body and clear it
func _on_body_entered(body: Node2D) -> void:
	if 'hit' in body:
		body.hit()
	if type == Data.Gun.ROCKET:
		explode.emit(position)
	queue_free()

# Disable bullet collision shape and emulate it exiting in front of player sprite
func _ready() -> void:
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(0.2).timeout
	$CollisionShape2D.disabled = false
