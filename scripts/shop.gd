class_name Shop extends Control


@export var items_amount: int = 5
@onready var shop_inventory: Control = %ShopInventory
@onready var refresh_button: Button = %Refresh
@export var items_list: Array[ItemData] = []


func _ready() -> void:
	refresh_button.pressed.connect(refresh)
	for i in shop_inventory.get_child_count():
		shop_inventory.get_child(i).index = i


func spawn_items() ->void:
	for i in shop_inventory.get_child_count():
		var slot = shop_inventory.get_child(i)
		slot.become_empty()


	for i in items_amount:
		var slot = shop_inventory.get_child(i)
		var item = items_list.pick_random().duplicate()
		item.inventory_index = i
		print(item.inventory_index)
		slot.place_item(item)

func place_item(item_data: ItemData) ->void:
	var slot = shop_inventory.get_child(item_data.inventory_index)
	slot.place_item(item_data)

func refresh() ->void:
	PlayerData.money -= 1
	spawn_items()
