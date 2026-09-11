class_name Inventory
extends Node

@onready var window:Panel = get_node("InventoryWindow")
@onready var info_text:Label = get_node("InventoryWindow/InfoText")
@export var starter_items:Array[Item]

var slots:Array[InventorySlot]

# Start with inventory closed 
func _ready():
	toggle_window(false)
	# Read every slot and clear its content, then set it back to the inventory
	for child in get_node("InventoryWindow/SlotContainer").get_children():
		slots.append(child)
		child.set_item(null)
		child.inventory = self
	
	# Connect signal to local give_player_item function
	GlobalSignals.on_give_player_item.connect(on_give_player_item)
	
	# Add all starter items to the inventory
	for item in starter_items:
		add_item(item)

# Check if inventory button is pressed then close it (if visible) or open it (if hidden 
func _process(delta):
	if Input.is_action_just_pressed("inventory"):
		toggle_window(!window.visible)

# Open or close inventory window
func toggle_window(open:bool):
	window.visible = open
	if open:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Give player "amount"-times the item
func on_give_player_item(item:Item,amount:int):
	for i in range(amount):
		add_item(item)

# Find a open slot and add a item to it
func add_item(item:Item):
	var slot = get_slot_to_add(item)
	
	# Check if there are no available slots, if so, early return the function  
	if slot == null:
		return
	# Check if the slot is available, then add the item
	if slot.item == null:
		slot.set_item(item)
	# Also check if there is already the selected item in the slot, then add it to the slot
	elif slot.item == item:
		slot.add_item()

# Find a certain slot and remove its item
func remove_item(item:Item):
	var slot = get_slot_to_remove(item)
	
	# Check if the slot is already empty
	if slot == null or slot.item != null:
		return
	
	slot.remove_item()

# Find acceptable slot for the item
func get_slot_to_add(item:Item) -> InventorySlot:
	# Check for the correct slot for the selected item and isn't maxed out
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack_size:
			return slot
	# Also check a available slot for the item
	for slot in slots:
		if slot.item == null:
			return slot
	return null

# Find the slot containg item to remove it
func get_slot_to_remove(item:Item) -> InventorySlot:
	for slot in slots:
		if slot.item == null:
			return slot
	return null

# Get item quantity 
func get_number_of_item(item:Item) -> int:
	var total = 0
	
	for slot in slots:
		if slot.item == item:
			total += slot.quantity
	
	return total
