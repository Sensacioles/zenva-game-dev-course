extends Sprite2D

func _ready() -> void:
	# Move by individual coordinate
	position.x = 200
	position.y = 300
	
	# Move both coordinates at once
	position = Vector2(200,300)

# Set player's speed 
var speed:float = 10.0 

# Set player's direction (x,y)
var direction = Vector2(1,1)
func _process(delta: float) -> void:
	position += speed * delta * direction
