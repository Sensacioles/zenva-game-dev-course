extends Marker2D

@export var type:Data.Enemy # Export enemy type to the inspector
var unique_id:String # Enemy distinct ID code
# Set defeated value and write into the enemy dictionary
var defeated:bool:
	set(value):
		defeated = value
		Data.enemy_data[unique_id]['defeated'] = value

# Enter entity tree and check if ID is not in Data.enemy_data, 
# if not, add a new entry whose defeated value matches spawner’s current value (default is false).
# If ID is already present copy the stored defeated value back into spawner.
func _enter_tree() -> void:
	unique_id = get_unique_id()
	if unique_id not in Data.enemy_data:
		Data.enemy_data[unique_id] = {'defeated': defeated}
	else:
		defeated = Data.enemy_data[unique_id]['defeated']

func get_unique_id() -> String:
	var scene_name = get_owner().scene_file_path.get_file().get_basename()
	return str(scene_name) + "_" + str(name)
