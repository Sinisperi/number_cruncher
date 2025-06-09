class_name DamageNeighbour extends AbilityData



func _activate() ->void:
	var n = Refs.workspace.select_random_neighbour(Refs.workspace.current_damaged_number_index)
	if n: 
		n.take_damage(PlayerData.damage, false)
