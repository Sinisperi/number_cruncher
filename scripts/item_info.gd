class_name ItemInfo extends Control


var title: String
var description: String
var price: int
var is_oriented_down: bool = true
@onready var price_container: HBoxContainer = %PriceContainer
@onready var the_container: PanelContainer = %TheContainer
@onready var information: MarginContainer = %Information
@onready var rarity_label: Label = %Rarity
@onready var rarity_label_glow: Label = %RarityGlow


@export var common_color: Color
@export var uncommon_color: Color
@export var rare_color: Color
@export var epic_color: Color

var shrink_expand_duration: float = 0.1

var mouse_offset: Vector2 = Vector2.ZERO

func update_info(item_data: ItemData) ->void:
	%Price.text = str(item_data.price)
	%Name.text = item_data.name
	%Description.text = item_data.description
	style_rarity(item_data.rarity)

func style_rarity(r: ItemData.Rarity) -> void:
	match r:
		ItemData.Rarity.COMMON:
			rarity_label.text = "COMMON"
			rarity_label.modulate = common_color
			rarity_label_glow.modulate = common_color + Color.WHITE
			rarity_label_glow.text = "COMMON"

		ItemData.Rarity.UNCOMMON:
			rarity_label.text = "UNCOMMON"
			rarity_label.modulate = uncommon_color
			rarity_label_glow.modulate = uncommon_color + Color.WHITE * 2
			rarity_label_glow.text = "UNCOMMON"


		ItemData.Rarity.RARE:
			rarity_label.text = "RARE"
			rarity_label.modulate = rare_color
			rarity_label_glow.modulate = rare_color + Color.WHITE * 2
			rarity_label_glow.text = "RARE"

		ItemData.Rarity.EPIC:
			rarity_label.text = "EPIC"
			rarity_label.modulate = epic_color
			rarity_label_glow.modulate = epic_color + Color.WHITE * 2
			rarity_label_glow.text = "EPIC"

func _ready() ->void:
	do_orientation()
	expand()
	self.position = get_global_mouse_position() - mouse_offset

func _physics_process(_delta: float) -> void:
	self.position = get_global_mouse_position() - mouse_offset

func set_price_hidden(is_hidden: bool = true) ->void:
	if is_hidden:
		price_container.hide()
	else:
		price_container.show()

func _enter_tree() -> void:
	pass

func do_orientation() ->void:
	if !is_oriented_down:
		mouse_offset.y = the_container.size.y

func expand() ->void:
	var size_before = the_container.size
	information.hide()
	self.hide()
	the_container.size = Vector2.ZERO
	var tween = self.create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(the_container, "size", size_before, shrink_expand_duration).set_delay(0.2).set_ease(Tween.EASE_IN)
	tween.parallel()
	tween.tween_callback(func() ->void: self.show()).set_delay(0.2)
	if !is_oriented_down:
		tween.parallel()
		tween.tween_property(the_container, "position:y", the_container.position.y, shrink_expand_duration).from(the_container.position.y + mouse_offset.y).set_delay(0.2).set_ease(Tween.EASE_IN)

	await tween.finished
	information.show()
