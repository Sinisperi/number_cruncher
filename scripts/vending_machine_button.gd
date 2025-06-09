class_name VendingMachineButton extends Button


signal v_pressed(code: String)


func _ready() ->void:
	self.pressed.connect(func() ->void: v_pressed.emit(self.text.to_lower()))
