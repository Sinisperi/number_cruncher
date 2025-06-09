class_name Workspace extends Control
@onready var quota_progress: TextureProgressBar = %QuotaProgress
@onready var attempts_container: AttemptsContainer = %AttemptsContainer
@onready var level_label: Label = %Level
@onready var next_level_button: Button = %NextLevel
@onready var number_container: NumberContainer = %NumberContainer
@onready var money_indicator: MoneyIndicator = %MoneyIndicator
@onready var shut_down_button: Button = %ShutDown


@onready var crt_overlay: TextureRect = %CRTOverlay

var current_damaged_number_index: int = -1


signal next_level_button_pressed
signal level_cleared

@export var curve: Curve

@onready var WORKSPACE_DIR: Dictionary = {
	"left": -1,
	"right": 1,
	"up" : -number_container.columns,
	"down" : number_container.columns,
	}

var current_crunched: int:
	set(value):
		current_crunched = value
		quota_progress.update(current_crunched)

var current_attempts: int:
	set(value):
		var diff = value - current_attempts
		current_attempts = value
		attempts_container.update(diff)



var quota: int = 3
var mult: int = 2

@onready var turn_timer: Timer = Timer.new()

func _ready() ->void:
	EventBus.number_damaged.connect(_on_number_damaged)
	next_level_button.pressed.connect(_on_next_level_button_pressed)
	shut_down_button.pressed.connect(_on_shut_down_button_pressed)
	self.level_cleared.connect(_on_level_cleared)

	PlayerData.init_player()
	Refs.workspace = self
	quota_progress.init(quota)
	init_turn_timer()
	init_workspace()





func _on_turn_timer_timeout() ->void:
		if !current_attempts:
			if quota > current_crunched:
				game_over()
			else:
				level_cleared.emit()



func _on_number_damaged(dmg: int) ->void:
	current_crunched += dmg

func init_workspace() ->void:
	current_crunched = 0
	current_attempts = PlayerData.max_attempts
	level_label.text = str(PlayerData.current_level)
	next_level_button.disabled = true
	number_container.populate_grid()
	%Damage.text = str(PlayerData.damage)
	calculate_new_quota()
	quota_progress.init(quota)


# TODO do something for it to make sense
func calculate_new_quota() ->void:
	#mult = curve.sample(PlayerData.current_level)
	mult = int(pow(PlayerData.current_level, 2.0))
	quota = max(3, mult * 2  - 1)
	prints("quota", quota, ceil(mult * 2) - 1)
	number_container.number_mult = max(1, mult) 
	print(mult)



func _on_next_level_button_pressed() ->void:
	PlayerData.current_level += 1
	next_level_button_pressed.emit()
	init_workspace()

func select_random_number() ->CrunchableNumber:
	return number_container.get_child(randi_range(0, number_container.get_child_count() - 1))

func select_random_neighbour(index: int) ->CrunchableNumber:
	var direction: int = [
		-1,
		1,
		-number_container.columns,
		number_container.columns
		].pick_random()

	var res = index + direction
	if res > (number_container.dimentions.x * number_container.dimentions.y) - 1:
		return null
	return number_container.get_child(res)

func get_all_neighbors(index: int) ->Array[CrunchableNumber]:
	var directions: Array[int] = [
		WORKSPACE_DIR.up,
		WORKSPACE_DIR.down,
		WORKSPACE_DIR.left,
		WORKSPACE_DIR.right,
		WORKSPACE_DIR.left + WORKSPACE_DIR.up,
		WORKSPACE_DIR.left + WORKSPACE_DIR.down,
		WORKSPACE_DIR.right + WORKSPACE_DIR.up,
		WORKSPACE_DIR.right + WORKSPACE_DIR.down
		]
	
	var res: Array[CrunchableNumber] = []
	for dir in directions:
		var num_ind: int = index + dir
		if num_ind > (number_container.dimentions.x * number_container.dimentions.y) - 1: continue
		res.push_back(number_container.get_child(num_ind))
	return res


func _on_level_cleared() ->void:
	next_level_button.disabled = false


func init_turn_timer() ->void:
	turn_timer.wait_time = 0.5;
	turn_timer.one_shot = true
	add_child(turn_timer)
	turn_timer.timeout.connect(_on_turn_timer_timeout)


func game_over() ->void:
	SceneLoader.load_scene(SceneLoader.GAME_OVER)


func _on_shut_down_button_pressed() ->void:
	SceneLoader.load_scene(SceneLoader.START_MENU)
