extends Node


# TODO potentially move outside of dict to allow for setters
var inventory: Array[ItemData] = []
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

var max_attempts: int = 0


func add_to_inventory(ability: AbilityData) ->void:
	for i in inventory:
		if i.inventory_index == ability.inventory_index:
			return
	inventory.push_back(ability)

func remove_from_inventory(ability: AbilityData) ->void:
	inventory = inventory.filter(func(i: AbilityData) ->bool: return i.inventory_index != ability.inventory_index)



func activate_abilities_on_attempt() ->void:
	for i in inventory:
		if i.activation_flags & AbilityData.ATTEMPT:
			i._activate()

func activate_abilities_on_damage() ->void:
	for i in inventory:
		if i.activation_flags & AbilityData.DAMAGE:
			i._activate()

func activate_abilities_on_crunch() ->void:
	for i in inventory:
		if i.activation_flags & AbilityData.CRUNCH:
			i._activate()

func init_player() ->void:
	current_level = 1
	damage = 100
	max_attempts = 1
	money = 10
