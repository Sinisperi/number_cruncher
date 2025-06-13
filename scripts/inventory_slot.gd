class_name InventorySlot extends PanelContainer

var is_taken: bool = false
@export var is_locked: bool = true


# pick item from the item_container
# drag it
# if drop not on the inventory slot, return back:qwq
var item: ItemData = null
var index: int = -1
@export var is_shop: bool = false
@onready var locked_icon: TextureRect = %LockedIcon
@onready var init_position: Vector2 = self.position



func _ready() ->void:
	self.gui_input.connect(_on_gui_input)
	self.mouse_entered.connect(_on_hover)
	self.mouse_exited.connect(_on_unhover)
	if is_locked:
		locked_icon.show()
	else:
		locked_icon.hide()
	if is_shop:
		var tween = self.create_tween().set_loops()
		tween.tween_property(self, "position", position + Vector2(randf_range(-3.0, 3.0), randf_range(-3.0, 3.0)), 1)
		tween.tween_property(self, "position", position, 1)


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

# switch items in hand when dropping on top of the taken inventory slot

func place_item(item_data: ItemData) ->void:
	if is_taken: print("is taken")
	
	if is_locked: return
	if Refs.main && Refs.main.currently_held_item:
		if !Refs.main.currently_held_item.is_bought:
			# buying item
			if !is_shop:
				PlayerData.money -= Refs.main.currently_held_item.item_data.price
				Refs.main.currently_held_item.is_bought = true
		else:
			pass
			# selling item back in the shop
			#if is_shop:

			#	PlayerData.remove_from_inventory(item_data)
			#	PlayerData.money += Refs.main.currently_held_item.item_data.price
			#	Refs.main.currently_held_item.is_bought = false




		if is_taken && !is_shop:
			var temp = item.duplicate()
			Refs.main.create_draggable_item(temp, get_global_mouse_position(), true)
			PlayerData.remove_from_inventory(temp)
		# placing stuff in the inventory

		if !is_taken:
			Refs.main.destroy_draggable_item()




	item_data.inventory_index = index


	if !is_shop: 
		PlayerData.add_to_inventory(item_data)

		print("placed in the invenroty")

	$TextureRect.texture = item_data.texture
	is_taken = true
	item = item_data


func become_empty() ->void:
	if !is_shop:
		PlayerData.remove_from_inventory(item)
	item = null
	$TextureRect.texture = null
	is_taken = false


func _on_hover() ->void:
	if is_taken:
		Refs.main.create_item_info(item, true if is_shop else false)

func _on_unhover() ->void:
	Refs.main.destroy_item_info()


func unlock_slot() ->void:
	is_locked = false
	%LockedIcon.hide()
