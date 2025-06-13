class_name DraggableItem extends Sprite2D

var is_picked = true
var item_data: ItemData
var is_bought: bool = false
func _ready() -> void:
	self.texture = item_data.texture


func _physics_process(_delta: float) -> void:
	if is_picked:
		position = get_global_mouse_position()

func get_sucked_in() ->void:
	is_picked = false
	var black_hole = get_tree().get_first_node_in_group("black_hole")
	var target_position = black_hole.global_position
	prints(target_position, self.global_position)

	var tween = self.create_tween().set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.set_parallel()
	tween.tween_property(self, "global_position", target_position, 0.1).from_current()
	await tween.finished
	queue_free()
