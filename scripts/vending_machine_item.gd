class_name VendingMachineItem extends TextureRect


var data: ConsumableItem = null
var is_empty: bool = false


func _ready() ->void:
	if !data: 
		is_empty = true
		return
	self.texture = data.texture
	self.mouse_entered.connect(_on_hover)
	self.mouse_exited.connect(_on_unhover)

func purchase() ->void:
	is_empty = true
	self.texture = null
	self.mouse_entered.disconnect(_on_hover)
	self.mouse_exited.disconnect(_on_unhover)

func _on_hover() ->void:
	if is_empty: return
	Refs.main.create_item_info(data)


func _on_unhover() ->void:
	Refs.main.destroy_item_info()
