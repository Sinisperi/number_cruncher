class_name Inventory extends HBoxContainer

var child_amount: int = 0

func _ready() ->void:
	for i in get_child_count():
		get_child(i).index = i

func place_item() ->void:
	var chi = Refs.main.currently_held_item
	if chi && chi.is_bought:
		var slot = get_child(chi.item_data.inventory_index)
		slot.place_item(chi.item_data)
