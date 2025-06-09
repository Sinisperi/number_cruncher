class_name AbilityData extends ItemData

@export_flags("Attempt", "Damage", "Crunch") var activation_flags = 0
enum {
	ATTEMPT = 1 << 0,
	DAMAGE = 1 << 1,
	CRUNCH = 1 << 2
	}
func _activate() ->void:
	pass
