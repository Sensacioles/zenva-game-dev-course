extends Area2D

var path_follow:PathFollow2D # Followable path
var health:int
var speed:int # Enemy speed
var prog_ratio_end:= 0.99 # Set end based on progress ratio

# Add new followable path
func setup(new_path_follow:PathFollow2D,type:Data.Enemy):
	path_follow = new_path_follow
	health = Data.ENEMY_DATA[type]['health']
	speed = Data.ENEMY_DATA[type]['speed']
	$Sprite2D.texture = load(Data.ENEMY_DATA[type]['texture'])
	position += Vector2(randi_range(-4,4), randi_range(-4,4))

# Follow the path for each frame
func _process(delta: float) -> void:
	path_follow.progress += speed * delta
	# Check if enemy reach progress ratio limit
	if path_follow.progress_ratio >= prog_ratio_end:
		Data.health -= 1
		queue_free()

# Delete any bullets that enter collision area, subtracts enemy health and add money when it is defeated
func _on_area_entered(bullet: Area2D) -> void:
	bullet.queue_free()
	hit()

func hit():
	health -= 1
	flash()
	if health <= 0:
		Data.money += 1
		queue_free()

func flash():
	var tween = create_tween()
	tween.tween_property($Sprite2D.material, 'shader_parameter/Progress', 1.0, 0.2)
	tween.tween_property($Sprite2D.material, 'shader_parameter/Progress', 0.0, 0.2)
