class_name StartMenu extends Control

@onready var crunch_button: Button = %Crunch
@onready var quit_button: Button = %Quit


func _ready() ->void:
	crunch_button.pressed.connect(_on_crunch_button_pressed)
	quit_button.pressed.connect(_on_quit_button_pressed)



func _on_crunch_button_pressed() ->void:
	SceneLoader.load_scene(SceneLoader.MAIN)


func _on_quit_button_pressed() ->void:
	get_tree().quit()
