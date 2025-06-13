class_name Main extends Control


var currently_held_item: DraggableItem = null
var current_item_info: ItemInfo = null
var draggable_item_scene: PackedScene = preload("uid://bxhgb303nu0jb")
var item_info_scene: PackedScene = preload("uid://cl5xgj3gl7wiq")

@onready var crt_overlay: TextureRect = %CRTOverlay
@onready var vending_machine: VendingMachine = %VendingMachine
@onready var shop: Shop = %Shop
@onready var workspace: Workspace = %Workspace
@onready var inventory: Inventory = %Inventory




@onready var to_left_button: Button = %ToLeft
@onready var to_right_button: Button = %ToRight


@onready var left_position: int = -get_viewport().get_size().x
@onready var right_position: int = get_viewport().get_size().x

var place_list: Array[Place] = [Place.SHOP, Place.WORKSPACE, Place.VENDING_MACHINE]
var current_place_index: int = 1

enum Place {
	WORKSPACE,
	SHOP,
	VENDING_MACHINE
}

func _ready() -> void:
	Refs.main = self
	workspace.next_level_button_pressed.connect(start_new_level)
	workspace.level_cleared.connect(_on_level_cleared)

	to_left_button.pressed.connect(_to_left_button_pressed)
	to_right_button.pressed.connect(_to_right_button_pressed)
	_on_window_resized()
	get_tree().root.size_changed.connect(_on_window_resized)
	self.gui_input.connect(_on_gui_input)
	start_new_level()
	change_buttons()

func _on_gui_input(event: InputEvent) -> void:
	if !currently_held_item: return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				# by this point we know that we are holding the item
				if currently_held_item.is_bought:
					inventory.place_item()
					return
				shop.place_item(currently_held_item.item_data)

func _on_window_resized() ->void:
	crt_overlay.material.set("shader_parameter/resolution", get_viewport().size * 1.5)

func create_item_info(item_data: ItemData, is_oriented_down: bool = true) ->void:
	if !current_item_info:
		current_item_info = item_info_scene.instantiate()
		current_item_info.is_oriented_down = is_oriented_down
		add_child(current_item_info)
		move_child(current_item_info, -2)
		current_item_info.update_info(item_data)


func destroy_item_info() ->void:
	if current_item_info:
		current_item_info.queue_free()
		current_item_info = null



func create_draggable_item(item_data: ItemData, pos: Vector2, is_bought: bool = true) ->void:
	var draggable_item = draggable_item_scene.instantiate()
	destroy_draggable_item()
	draggable_item.position = pos
	draggable_item.is_bought = is_bought
	draggable_item.item_data = item_data
	currently_held_item = draggable_item
	add_child(draggable_item)


func destroy_draggable_item() ->void:
	if currently_held_item:
		currently_held_item.queue_free()
		currently_held_item = null


func start_new_level() ->void:
	to_left_button.disabled = true
	to_right_button.disabled = true


func _on_level_cleared() ->void:
	to_left_button.disabled = false
	to_right_button.disabled = false

	shop.refresh()
	vending_machine.refresh()


func _to_left_button_pressed() ->void:
	var prev = current_place_index
	current_place_index -= 1
	if current_place_index < 0:
		current_place_index = place_list.size() - 1
	var panel = place_to_panel(place_list[current_place_index])
	slide_place_in(panel, prev, true)
	change_buttons()

func _to_right_button_pressed() ->void:
	var prev = current_place_index
	current_place_index += 1
	if current_place_index >= place_list.size():
		current_place_index = 0
	var panel = place_to_panel(place_list[current_place_index])
	slide_place_in(panel, prev, false)
	change_buttons()

func change_buttons() ->void:
	var left_index: int = current_place_index - 1
	if left_index < 0: left_index = place_list.size() - 1
	var right_index: int = current_place_index + 1
	if right_index >= place_list.size(): right_index = 0
	var left: String = place_to_string(place_list[left_index])
	var right: String = place_to_string(place_list[right_index])
	to_left_button.set_text_string(left)
	to_right_button.set_text_string(right)

func place_to_string(place: Place) ->String:
	match place:
		Place.WORKSPACE:
			return "Workspace"
		Place.SHOP:
			return "Shop"
		Place.VENDING_MACHINE:
			return "Vending Machine"
		_:
			return "Place does not exist"


func place_to_panel(place: Place) ->Node:
	match place:
		Place.WORKSPACE:
			return workspace
		Place.SHOP:
			return shop
		Place.VENDING_MACHINE:
			return vending_machine
		_:
			return null


func slide_place_in(panel: Node, previous_index: int, from_left: bool = true) ->void:
	var trans_speed: float = 0.5
	to_left_button.disabled = true
	to_right_button.disabled = true
	panel.global_position.x = left_position if from_left else right_position
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(panel, "global_position:x", 0, trans_speed)
	var tween2 = get_tree().create_tween().set_trans(Tween.TRANS_BACK)
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.tween_property(place_to_panel(place_list[previous_index]), "global_position:x", right_position if from_left else left_position, trans_speed)
	await tween.finished
	await tween2.finished
	to_left_button.disabled = false
	to_right_button.disabled = false
