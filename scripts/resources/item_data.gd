class_name ItemData extends Resource

enum Rarity{
	COMMON = 50,
	UNCOMMON = 30,
	RARE = 20,
	EPIC = 10
}

var weight_top: int
var weight_bottom: int

@export var name: String
@export var texture: Texture2D
@export var price: int
@export var rarity: Rarity = Rarity.COMMON
@export_multiline var description: String
var inventory_index: int = -1
