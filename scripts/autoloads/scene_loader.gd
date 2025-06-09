extends Node


var current_scene: Node = null

const START_MENU: String = "uid://cpq01qqmcqdi1"
const MAIN: String = "uid://6mxejg3yfpie"
const GAME_OVER: String = "uid://pcy30ji4ipqo"

func _ready() ->void:
	current_scene = get_tree().root.get_child(-1)


func load_scene(scene_name: String) ->void:
	call_deferred("_load_scene", scene_name)



func _load_scene(scene_name: String) ->void:
	if current_scene:
		var new_scene = ResourceLoader.load(scene_name).instantiate()
		var root = get_tree().root
		root.remove_child(current_scene)
		current_scene.free()
		root.add_child(new_scene)
		current_scene = new_scene
