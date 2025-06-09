class_name AttemptsContainer extends PanelContainer


@onready var attempts_list: VBoxContainer = %AttemptsList

func _ready() ->void:
	init()


func init() ->void:
	pass

func update(diff: int) ->void:
	
	if diff < 0:
		var att_to_remove_count: int =  abs(diff)
		for i in attempts_list.get_child_count():
			var att = attempts_list.get_child(attempts_list.get_child_count() - i - 1 )
			if att.is_active:
				att.use()
				att_to_remove_count -= 1
				if att_to_remove_count <= 0:
					break
	elif diff > 0:
		var att_to_activate_count: int = diff
		for i in attempts_list.get_child_count():
			var att = attempts_list.get_child(i) 
			if !att.is_active:
				att.activate()
				att_to_activate_count -= 1
				if att_to_activate_count <= 0:
					break
	
			
