class_name NumberContainer extends GridContainer


@export var dimentions: Vector2i = Vector2i(10, 10)
@export var number_scene: PackedScene
@export var number_mult: int = 1


func _ready() ->void:
	self.columns = dimentions.x



func populate_grid() ->void:
	while get_child_count():
		var num_to_delete: CrunchableNumber = get_child(-1)
		remove_child(num_to_delete)
		num_to_delete.queue_free()
	
	for i in dimentions.x * dimentions.y:
		var n = number_scene.instantiate()
		n.setup( randi_range(1 * number_mult, 10 * number_mult))
		n.index = i
		add_child(n)
