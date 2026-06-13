extends Node2D

var enemy_scene = preload("res://scenes/enemies/enemy.tscn") # Preload enemy scene
var bullet_scene = preload("res://scenes/bullets/bullet.tscn") # Preload bullet scene
# Set tower placement state 
var place_tower:bool:
	set(value):
		place_tower = value 
		$Background/TowerPreview.visible = true
var selected_tower:Data.Tower # Current selected tower
# Tower scenes dictionary
var tower_scenes = {
	Data.Tower.BASIC: "res://scenes/towers/tower_basic.tscn"
}
var used_cells:Array[Vector2i] # Store used tiles

func _ready():
	#var path_follow = PathFollow2D.new() # Create enemy path
	#var enemy = enemy_scene.instantiate() # Instantiate enemy

	#enemy.setup(path_follow) # Assign path to new enemy

	#path_follow.add_child(enemy) # Add enemy to path
	#$Path2D.add_child(path_follow) # Add sprite to path
	#$Towers/TowerBasic.connect("shoot", create_bullet) # Connect tower shoot signal to a new bullet
	RenderingServer.set_default_clear_color('dff6f5') # Paint non-filled background with lightblue

# Setup bullets that will fire from a given position into a given angle
func create_bullet(pos: Vector2, angle: float, bullet_enum: Data.Bullet):
	var bullet = bullet_scene.instantiate()
	bullet.setup(pos, angle, bullet_enum)
	$Bullets.add_child(bullet)

# Enter placement mode and assign a given type of tower to the selected one
func _on_ui_place_tower(tower_type: Data.Tower) -> void:
	place_tower = true
	print(tower_type)
	selected_tower = tower_type
	$Background/TowerPreview.texture = load(Data.TOWER_DATA[tower_type]['thumbnail']) # Load currently selected tower's thumbnail

func _input(event:InputEvent) -> void:
	var raw_pos = get_local_mouse_position() # Get mouse position inside the scene
	var pos = Vector2i(raw_pos.x/16,raw_pos.y/16) # Get mouse coordinates relative to the grid  
	# Check if player is in tower placement mode
	if place_tower:
		# Detect mouse motion
		if event is InputEventMouseMotion:
			var tower_pos = pos*16+Vector2i(8,8) # Convert the position back to pixel perfect and correct the preview to the center of tile
			$Background/TowerPreview.position = tower_pos
		# Detect if left mouse (button_index=1) is clicked (button_mask=1)
		if event is InputEventMouseButton and event.button_mask == 1:
			var tile_data = $Background/TileMapLayer.get_cell_tile_data(pos) as TileData
			#Also check if pos is not taken. If it isn't, place the tower and disable placement mode
			if event.button_index == 1 and pos not in used_cells and tile_data is TileData and tile_data.get_custom_data('Usable'):
				used_cells.append(pos)
				var tower = load(tower_scenes[selected_tower]).instantiate()
				tower.position = pos*16+Vector2i(8,8)
				tower.connect('shoot',create_bullet)
				$Towers.add_child(tower)
				place_tower = false
				Data.money -= Data.TOWER_DATA[selected_tower]['cost']

	# Check if exit key is pressed and close placement mode
	if Input.is_action_just_pressed("exit"):
		place_tower = false

func _on_ui_start_wave() -> void:
	var data = Data.ENEMY_WAVES[Data.current_wave]
	Data.current_wave += 1
	for enemy_enum in data:
		for i in data[enemy_enum]:
			var path_follow = PathFollow2D.new()
			var enemy = enemy_scene.instantiate()
			enemy.setup(path_follow, enemy_enum)
			path_follow.add_child(enemy)
			$Path2D.add_child(path_follow)
			await get_tree().create_timer(0.5).timeout
