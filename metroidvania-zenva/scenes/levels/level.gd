extends Node2D

var bullet_scene = preload("res://scenes/bullets/bullet.tscn") # Pre-load bullet scene
var explosion_scene = preload("res://scenes/bullets/explosion.tscn") # Pre-load explosion scene
# Dictionary that maps each enemy type
var enemy_scenes = {
	Data.Enemy.DRONE:preload("res://scenes/characters/drone.tscn"),
	Data.Enemy.SOLDIER:preload("res://scenes/characters/soldier.tscn")
}
@onready var player = $Entities/Player

# Get every drone in the Drones group and set it up with the explosion scene 
func _ready() -> void:
	# For each spawn point, insantiate a new enemy and add it to the Entities group
	for spawn_point: Marker2D in $EnemySpawns.get_children():
		if spawn_point.defeated == false:
			var enemy = enemy_scenes[spawn_point.type].instantiate()
			enemy.setup(spawn_point)
			$Entities.add_child(enemy)
	for drone in get_tree().get_nodes_in_group('Drones'):
		drone.connect('explode',create_explosion)
	for soldier in get_tree().get_nodes_in_group('Soldiers'):
		soldier.connect('shoot', _on_player_shoot)

# Instantiate and set up new explosion
func create_explosion(pos:Vector2):
	var explosion = explosion_scene.instantiate()
	explosion.setup(pos)
	$Sounds/ExplosionSound.play()
	call_deferred('_add_explosion',explosion)

func _add_explosion(explosion):
	$Bullets.add_child(explosion)

# Instantiate the signalized bullet, add it to the Bullets container and
# set its position and direction
func _on_player_shoot(pos: Vector2, dir: Vector2, gun_type: Data.Gun) -> void:
	# If gun isn't the shotgun, spawn bullet normally
	if gun_type != Data.Gun.SHOTGUN:
		var bullet = bullet_scene.instantiate()
		bullet.connect('explode',create_explosion)
		$Bullets.add_child(bullet) 
		bullet.setup(pos, dir, gun_type)
		$Sounds/GunSound.play()
	# Otherwise, check if the aim's and enemy's angles meet for the shots to hit the enemies
	else:
		$Sounds/ShotgunSound.play()
		for enemy in get_tree().get_nodes_in_group('Enemies'):
			# Convert angle values to degress for better readability
			var aim_angle = rad_to_deg(dir.angle())
			var enemy_angle = rad_to_deg((enemy.position - pos).angle())
			# Check if the difference between angles is less than 90 degrees. Also check if player
			# is close enough to the enemy.
			if abs(aim_angle - enemy_angle) < 90 and pos.distance_to(enemy.position) < 100:
				enemy.hit()

# For each transition gate in the current level (if it has more than one), check if target gate
# matches the level parameter and, if so, move the player to the gate's last child (Marker2D).
func position_player(level: Data.Level):
	for gate in $Gates.get_children():
		if gate.target == level:
			player.position = gate.get_child(-1).global_position
