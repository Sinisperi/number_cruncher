class_name Inventory extends HBoxContainer

var child_amount: int = 0

func _ready() ->void:
	EventBus.inventory_slots_changed.connect(_on_inventory_slots_changed)
	var current_unlocked_slots = PlayerData.unlocked_inventory_slots
	for i in get_child_count():
		var slot = get_child(i)
		slot.index = i
		if current_unlocked_slots > 0:
			slot.unlock_slot()
			current_unlocked_slots -= 1


func place_item() ->void:
	var chi = Refs.main.currently_held_item
	if chi && chi.is_bought:
		var slot = get_child(chi.item_data.inventory_index)
		slot.place_item(chi.item_data)


		
func _on_inventory_slots_changed() ->void:
	var current_unlocked_slots = PlayerData.unlocked_inventory_slots
	print(current_unlocked_slots)
	for i in get_children():
		if current_unlocked_slots <= 0:
			break
		if !i.is_locked:
			current_unlocked_slots -= 1
			continue
		i.unlock_slot()
		current_unlocked_slots -= 1


		
