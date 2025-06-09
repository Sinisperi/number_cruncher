class_name HighScoreListItem extends HBoxContainer


@onready var name_label: Label = %Name
@onready var score_label: Label = %Score


func init(n: String, s: String) ->void:
	name_label.text = n
	score_label.text = s
