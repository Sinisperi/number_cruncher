class_name VendingMachine extends Control



@export var items_amount: int = 10
@export var vending_machine_item_scene: PackedScene
@export var stock: Array[ConsumableItem] = []
@onready var vending_machine_item_container: GridContainer = %ItemDisplay
@onready var purchase_button: Button = %Purchase
@onready var number_pad: GridContainer = %NumberPad
@onready var reset_button: Button = %Reset

@onready var row_lookup: Dictionary = {
	"a": 0,
	"b": vending_machine_item_container.columns,
	"c": vending_machine_item_container.columns * 2,
	"d": vending_machine_item_container.columns * 3,
	"e": vending_machine_item_container.columns * 4
}

var currently_selected_item_index: int = -1

var current_code: String = ""

func _ready() ->void:
	populate_slots()
	purchase_button.pressed.connect(_on_purchase_button_pressed)
	reset_button.pressed.connect(_on_reset_button_pressed)
	purchase_button.disabled = false
	connect_to_buttons()



func populate_slots() ->void:
	while vending_machine_item_container.get_child_count():
		var vmitd = vending_machine_item_container.get_child(-1)
		vending_machine_item_container.remove_child(vmitd)
		vmitd.queue_free()

	for i in items_amount:
		var vmi = vending_machine_item_scene.instantiate()
		if randf() < 0.9:
			vmi.data = stock.pick_random()
		vending_machine_item_container.add_child(vmi)


func _on_purchase_button_pressed() ->void:
	if !row_lookup.has(current_code[0]): return
	var selected_index = row_lookup[current_code[0]] + current_code[1].to_int() - 1
	print("code", current_code)
	if selected_index < vending_machine_item_container.get_child_count():
		var item = vending_machine_item_container.get_child(selected_index)
		if item.is_empty: 
			current_code = ""
			return
		item.modulate = Color.RED
		if PlayerData.money >= item.data.price:
			PlayerData.money -= item.data.price
			PlayerData.damage += item.data.effects.damage
			PlayerData.max_attempts += item.data.effects.attempts
			item.purchase()
		current_code = ""





func _on_item_selected(index: int) ->void:
	currently_selected_item_index = index
	purchase_button.disabled = false


func _on_vending_machine_button_pressed(code: String) ->void:
	current_code += code


func connect_to_buttons() ->void:
	for i in number_pad.get_children():
		if i is VendingMachineButton:
			i.v_pressed.connect(_on_vending_machine_button_pressed)

func _on_reset_button_pressed() ->void:
	current_code = ""


func refresh() ->void:
	populate_slots()
