class_name LootCreator


var item_list: Array[ItemData] = []


var total_item_weight: int = 0


func _init(items: Array[ItemData]) ->void:
	item_list = items
	_setup_randomness()


func _setup_randomness() ->void:
	var prev: int = 0
	for i in item_list:
		total_item_weight += i.rarity
		i.weight_bottom = prev + 1
		i.weight_top = i.weight_bottom + i.rarity
		prev = i.weight_top


func pick_item() ->ItemData:
	var roll = randi_range(1, total_item_weight)
	for i in item_list:
		if i.weight_bottom <= roll && i.weight_top >= roll:
			return i
	return null
	

