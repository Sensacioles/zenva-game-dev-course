class_name Tower extends Node2D # Define Tower class

var type:Data.Tower
var enemies:Array # Store enemies currently in range
var upgraded:bool # Check if tower is upgraded
var bullet_type:Data.Bullet # Get bullet type
var cost:int # Tower cost
var upgrade_cost:int # Tower upgrade cost

@warning_ignore("unused_signal") # Ignore shooting signal for the parent class
signal shoot(pos:Vector2, directio:float, bullet_enum:Data.Bullet) # Signals shots for child scenes
signal select(tower:Tower) # Signals tower to be selected

# Assign each tower reload timer its correct value based on tower type
func setup(tower_type: Data.Tower):
	$ReloadTimer.wait_time = Data.TOWER_DATA[tower_type]['reload_time']
	$TowerMenu.cost = Data.TOWER_DATA[tower_type]['upgrade_cost']
	bullet_type = Data.TOWER_DATA[tower_type]['bullet']
	cost = Data.TOWER_DATA[tower_type]['cost']
	upgrade_cost = Data.TOWER_DATA[tower_type]['upgrade_cost']
	type = tower_type

# Check if enemy enters detection area and add it from enemy array
func _on_enemy_detection_area_area_entered(area: Area2D) -> void:
	if area not in enemies:
		enemies.append(area)

# Check if enemy exits detection area and remove it from enemy array
func _on_enemy_detection_area_area_exited(area: Area2D) -> void:
	if area in enemies:
		enemies.erase(area)

func _process(delta: float) -> void:
	print(enemies)

# Check if left mouse button is clicked. If so, select clicked tower
func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == 1 and event.button_mask == 1:
		if not $DelayTimer.time_left:
			select.emit(self)
			$TowerMenu.reveal(upgraded)

# Upgrade tower if tower menu upgrade button is pressed
func _on_tower_menu_upgrade_press() -> void:
	tower_upgrade()
	$TowerMenu.hide()
	upgraded = true
	
# Upgrade tower
func tower_upgrade():
	$Base.texture = load("res://graphics/towers/basic/basic tower upgrade bottom.png")
	$Turret.texture = load("res://graphics/towers/basic/basic tower upgrade top.png")

# Return money if tower is deleted
func _on_tower_menu_delete_press() -> void:
	var return_money = cost if not upgraded else cost+upgrade_cost
	Data.money += return_money
	queue_free()

func hide_ui():
	$TowerMenu.hide()
