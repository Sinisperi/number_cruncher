class_name TransitionButton extends Button


@onready var label: Label = %Label

@export var is_left: bool = true

var default_font : Font = ThemeDB.fallback_font;

func _ready() ->void:
	if !is_left:
		label.rotation_degrees = 90


func set_text_string(s: String) ->void:
	label.text = s


	
