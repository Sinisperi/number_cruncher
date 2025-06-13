class_name Shop extends Control


@export var items_amount: int = 5
@onready var shop_inventory: Control = %ShopInventory
@onready var refresh_button: Button = %Refresh
@onready var refresh_text: RichTextLabel = %RefreshText
@onready var black_hole: TextureRect = %BlackHole
@export var items_list: Array[ItemData] = []

var total_item_weight: int = 0
var loot_creator: LootCreator = null

func _ready() -> void:
	refresh_button.pressed.connect(refresh)
	var hole_tween = self.create_tween().set_loops()
	hole_tween.tween_property(black_hole, "rotation_degrees", 360, 100).from_current()
	for i in shop_inventory.get_child_count():
		shop_inventory.get_child(i).index = i
	black_hole.gui_input.connect(_on_black_hole_gui_input)
	loot_creator = LootCreator.new(items_list)
	refresh_button.mouse_entered.connect(func() ->void: refresh_text.text = "[u]Refresh")
	refresh_button.mouse_exited.connect(func() ->void: refresh_text.text = "Refresh")

func _on_black_hole_gui_input(event: InputEvent) ->void:
	if !Refs.main.currently_held_item: return 

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if !Refs.main.currently_held_item.is_bought:
					place_item(Refs.main.currently_held_item.item_data)
					return
				var item = Refs.main.currently_held_item
				PlayerData.money += item.item_data.price
				Refs.main.currently_held_item.get_sucked_in()
				Refs.main.currently_held_item = null

func spawn_items() ->void:

	for i in shop_inventory.get_child_count():
		var slot = shop_inventory.get_child(i)
		slot.become_empty()

		var item = loot_creator.pick_item()
		if !item: break
		item.inventory_index = i
		slot.place_item(item)

func place_item(item_data: ItemData) ->void:
	var slot = shop_inventory.get_child(item_data.inventory_index)
	slot.place_item(item_data)

func refresh() ->void:
	PlayerData.money -= 1
	spawn_items()
