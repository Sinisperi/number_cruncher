class_name ItemInfo extends Control


var title: String
var description: String
var price: int
var is_oriented_down: bool = true
@onready var price_container: HBoxContainer = %PriceContainer
@onready var the_container: PanelContainer = %TheContainer

var mouse_offset: Vector2 = Vector2.ZERO

func update_info(item_data: ItemData) ->void:
	%Price.text = str(item_data.price)
	%Name.text = item_data.name
	%Description.text = item_data.description

func _ready() ->void:
	do_orientation()
	self.position = get_global_mouse_position() - mouse_offset

func _physics_process(_delta: float) -> void:
	self.position = get_global_mouse_position() - mouse_offset

func set_price_hidden(is_hidden: bool = true) ->void:
	if is_hidden:
		price_container.hide()
	else:
		price_container.show()


func do_orientation() ->void:
	#var bottom_left = get_viewport().get_mouse_position() + the_container.size
	#if bottom_left.y > get_viewport().get_visible_rect().size.y:
	if !is_oriented_down:
		mouse_offset.y = the_container.size.y
