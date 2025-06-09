class_name CrunchableNumber extends PanelContainer

@onready var label: Label = %Label
@onready var particles: GPUParticles2D = %Particles
@onready var damage_label: Label = %DamageLabel

## hp of a number
var value: int = 0
var max_value: int = 0
var index: int = -1
var is_cursed: bool = false
@onready var default_font_size: int = label.get("theme_override_font_sizes/font_size")
@onready var default_rotation: float = label.rotation_degrees


@export_range(0.01, 0.6) var hover_animation_duration: float = 0.4

signal pressed


@onready var scale_tween: Tween = null
@onready var shake_tween: Tween = null
@onready var damage_tween: Tween = null

func _ready() ->void:
	label.text = str(value)
	self.pressed.connect(on_click)

	if randf() < 0.1:
		is_cursed = true
		label.self_modulate = Color.RED
	
	

	self.mouse_entered.connect(play_hover_animation)
	self.mouse_exited.connect(play_unhover_animation)
	self.gui_input.connect(_on_gui_input)


# damage the number

func _on_gui_input(event: InputEvent) ->void:
	if value > 0:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.is_pressed():
					pressed.emit()

func on_click() -> void:
	if value <= 0 || !Refs.workspace.current_attempts: return

	take_damage(PlayerData.damage)

	PlayerData.activate_abilities_on_attempt()
	Refs.workspace.current_attempts -= 1


func setup(v: int) ->void:
	value = v
	max_value = v



func update_visuals() ->void:
	label.text = str(value)

func die() ->void:
	label.text = ""
	PlayerData.money += 1
	EventBus.number_crunched.emit()
	PlayerData.activate_abilities_on_crunch()
	play_crunch_animation()



func light_up() ->void:
	self.modulate = Color.BLUE_VIOLET


func take_damage(damage: int, propagate: bool = true) ->void:
	Refs.workspace.turn_timer.start()
	if value <= 0: 
		print("already 0")
		return
	var cursed_mod = -1 if is_cursed else 1
	Refs.workspace.current_damaged_number_index = index

	var resulting_damage = damage
	var diff = value - resulting_damage
	if diff >= 0:
		if is_cursed:
			EventBus.number_damaged.emit(cursed_mod * resulting_damage)
	else:
		if propagate && !is_cursed:
			propagate_damage(abs(diff))
	
	value -= resulting_damage
	play_damage_animation(cursed_mod * resulting_damage)
	update_visuals()
	if value < 1:
		EventBus.number_damaged.emit(cursed_mod * max_value)
		die()


func propagate_damage(damage: int) ->void:
	var rn = Refs.workspace.select_random_neighbour(index)
	if rn: 
		await get_tree().create_timer(0.3).timeout
		rn.take_damage(damage)


func play_hover_animation() ->void:
	expand()
	var neighbors: Array[CrunchableNumber] = Refs.workspace.get_all_neighbors(index)
	for n in neighbors:
		n.expand(true, 0.4, 1.5)
	if shake_tween:
		shake_tween.kill()
	shake_tween = self.create_tween().set_loops()
	shake_tween.tween_property(label, "rotation_degrees", label.rotation_degrees - 8, 0.2).from_current()

func play_unhover_animation() ->void:
	expand(false, 1.0, 0.1)
	var neighbors: Array[CrunchableNumber] = Refs.workspace.get_all_neighbors(index)
	for n in neighbors:
		n.expand(false)
	if shake_tween:
		shake_tween.kill()
	shake_tween = self.create_tween().set_loops()
	shake_tween.tween_property(label, "rotation_degrees", default_rotation, 0.3)



func play_damage_animation(damage: int) ->void:
	damage_label.global_position = self.global_position
	damage_label.text = "-" + str(damage)
	damage_label.show()
	if damage_tween:
		damage_tween.kill()
	damage_tween = self.create_tween().set_ease(Tween.EASE_IN_OUT)
	damage_tween.tween_property(damage_label, "global_position", self.global_position + Vector2(0, -14), .2)
	await damage_tween.finished
	damage_label.hide()

func play_crunch_animation() ->void:
	particles.emitting = true


func expand(up: bool = true, ratio: float = 1.0, duration_ratio: float = 1.0) ->void:
	if scale_tween:
		scale_tween.kill()
	scale_tween = self.create_tween()
	scale_tween.tween_property(label, "theme_override_font_sizes/font_size", int(default_font_size + 10 * ratio) if up else default_font_size, hover_animation_duration * duration_ratio)
	
