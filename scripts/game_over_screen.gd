class_name GameOverScreen extends Control


@onready var to_main_menu_button: Button = %ToMainMenu
@onready var score_label: Label = %Score
@onready var high_score_label: Label = %HighScore
@onready var high_score_container: HBoxContainer = %HighScoreContainer
@onready var score_container: HBoxContainer = %ScoreContainer
@onready var new_high_score_label: Label = %NewHighScore

var save_path: String = "res://save.json"



func _ready() -> void:
	to_main_menu_button.pressed.connect(_on_to_main_menu_button_pressed)
	do_high_score()


func _on_to_main_menu_button_pressed() ->void:
	SceneLoader.load_scene(SceneLoader.START_MENU)


func save_high_score() ->void:
	var save_file = FileAccess.open(save_path, FileAccess.WRITE)
	save_file.store_var(PlayerData.current_level - 1)


func get_high_score() ->int:
	if !FileAccess.file_exists(save_path):
		print("no file exists")
		return 0
	var save_file = FileAccess.open(save_path, FileAccess.READ)
	var high_score = save_file.get_var()
	while save_file.get_position() < save_file.get_length():
		high_score = save_file.get_var()
	return high_score


func do_high_score() ->void:
	var prev_high_score = get_high_score()
	if prev_high_score <= PlayerData.current_level - 1:
		save_high_score()
		score_label.text = str(PlayerData.current_level - 1)
		high_score_container.hide()
	else:
		new_high_score_label.hide()
		score_label.text = str(PlayerData.current_level - 1)
		high_score_label.text = str(prev_high_score)

	
