class_name DamageRandom extends AbilityData



func _activate() ->void:
	var n = Refs.workspace.select_random_number()
	if n:
		n.take_damage(PlayerData.damage, false)
