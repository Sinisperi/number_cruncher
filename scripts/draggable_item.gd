class_name DraggableItem extends Sprite2D

var is_picked = true
var item_data: ItemData
var is_bought: bool = false

func _ready() -> void:
	self.texture = item_data.texture


func _physics_process(_delta: float) -> void:
	if is_picked:
		position = get_global_mouse_position()
