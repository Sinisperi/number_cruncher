class_name MoneyIndicator extends HBoxContainer


@onready var money_label: Label = %Money



func _ready() ->void:
	money_label.text = str(PlayerData.money)
	EventBus.money_changed.connect(_on_money_changed)


func _on_money_changed() ->void:
	money_label.text = str(PlayerData.money)
