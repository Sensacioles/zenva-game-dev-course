extends InteractableObject

@export var item_name:String

# Reference the item resource by its path. The item resource stores a scene in itself,
# referencing it by its type would cause a recursion problem as the world item would
# point to the item scene and the item scene to the world item
func _interact():
	var item = load("res://Items/Item Data/" + item_name + ".tres")
	GlobalSignals.on_give_player_item.emit(item, 1)
	queue_free()
