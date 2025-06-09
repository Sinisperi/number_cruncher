class_name QuotaProgress extends TextureProgressBar


@onready var current_label: Label = %Current
@onready var quota_label: Label = %Quota
@onready var tween: Tween = null

func init(quota: int) ->void:
	self.max_value = quota
	current_label.text = str(0)
	quota_label.text = str(quota)


func update(n: int) ->void:
	if tween:
		tween.kill()
	tween = self.create_tween()
	tween.tween_property(self, "value", n, 0.9)
	#self.value = n
	current_label.text = str(n)

