extends Node


var inventory: Array[ItemData] = [null, null, null, null, null, null, null, null, null]
var money: int:
	set(value):
		money = value
		EventBus.money_changed.emit()

var current_level: int:
	set(value):
		current_level = value
		EventBus.current_level_changed.emit()

var damage: int:
	set(value):
		damage = value
		EventBus.damage_changed.emit()

var unlocked_inventory_slots: int :
	set(value):

		unlocked_inventory_slots = clamp(value, 0, 9)
		EventBus.inventory_slots_changed.emit()


var max_attempts: int = 0


func add_to_inventory(ability: AbilityData) ->void:
	inventory[ability.inventory_index] = ability

func remove_from_inventory(ability: AbilityData) ->void:
	inventory[ability.inventory_index] = null



func activate_abilities_on_attempt() ->void:
	for i in inventory:
		if !i: continue
		if i.activation_flags & AbilityData.ATTEMPT:
			i._activate()

func activate_abilities_on_damage() ->void:
	for i in inventory:
		if !i: continue
		if i.activation_flags & AbilityData.DAMAGE:
			i._activate()

func activate_abilities_on_crunch() ->void:
	for i in inventory:
		if !i: continue
		if i.activation_flags & AbilityData.CRUNCH:
			i._activate()

func init_player() ->void:
	current_level = 1
	damage = 100
	max_attempts = 1
	money = 100
	unlocked_inventory_slots = 3
