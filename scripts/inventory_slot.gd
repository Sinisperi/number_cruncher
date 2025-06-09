class_name InventorySlot extends PanelContainer

var is_taken: bool = false


# pick item from the item_container
# drag it
# if drop not on the inventory slot, return back:qwq
var item: ItemData = null
var index: int = -1
@export var is_shop: bool = false




func _ready() ->void:
	self.gui_input.connect(_on_gui_input)
	self.mouse_entered.connect(_on_hover)
	self.mouse_exited.connect(_on_unhover)

func _on_gui_input(event: InputEvent) ->void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if Refs.main.currently_held_item:
					place_item(Refs.main.currently_held_item.item_data)
				else:
					if !item: return
					if is_shop:
						if PlayerData.money > 0 && PlayerData.money >= item.price:
							Refs.main.create_draggable_item(item, get_global_mouse_position(), false)
							become_empty()
						return
					Refs.main.create_draggable_item(item, get_global_mouse_position(), true)
					become_empty()



func place_item(item_data: ItemData) ->void:
	
	if is_taken: return
	if Refs.main && Refs.main.currently_held_item:
		if !Refs.main.currently_held_item.is_bought:
			# buying item
			if !is_shop:
				PlayerData.money -= Refs.main.currently_held_item.item_data.price
				Refs.main.currently_held_item.is_bought = true
		else:
			# selling item back in the shop
			if is_shop:

				PlayerData.remove_from_inventory(item_data)
				PlayerData.money += Refs.main.currently_held_item.item_data.price
				Refs.main.currently_held_item.is_bought = false


		Refs.main.currently_held_item.queue_free()
		Refs.main.currently_held_item = null
		# placing stuff in the inventory
	item_data.inventory_index = index
	if !is_shop: 
		PlayerData.add_to_inventory(item_data)

		print("placed in the invenroty")

	$TextureRect.texture = item_data.texture
	is_taken = true
	item = item_data


func become_empty() ->void:
	item = null
	$TextureRect.texture = null
	is_taken = false


func _on_hover() ->void:
	if is_taken:
		Refs.main.create_item_info(item, true if is_shop else false)

func _on_unhover() ->void:
	Refs.main.destroy_item_info()
