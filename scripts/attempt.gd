class_name Attempt extends TextureRect



var is_active: bool = false
@onready var active_texture: TextureRect = %ActiveTexture


func _ready() ->void:
	if is_active:
		active_texture.show()



func use() ->void:
	active_texture.hide()
	is_active = false


func activate() ->void:
	active_texture.show()
	is_active = true
