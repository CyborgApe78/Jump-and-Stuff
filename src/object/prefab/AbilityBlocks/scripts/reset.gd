extends AbilityBlockBase

func _ready() -> void:
	body_entered.connect(_on_reset_entered)

func _on_reset_entered(body: Player) -> void: #TODO: Change to energy
	if ability == PlayerAbilities.list.All:
		Abilities.reset(PlayerAbilities.list.All)
	elif ability == PlayerAbilities.list.DashSide:
		Abilities.reset(PlayerAbilities.list.DashSide)
	elif ability == PlayerAbilities.list.DashUp:
		Abilities.reset(PlayerAbilities.list.DashUp)
	elif ability == PlayerAbilities.list.DashDown:
		Abilities.reset(PlayerAbilities.list.DashDown)
	elif ability == PlayerAbilities.list.Dash:
		Abilities.reset(PlayerAbilities.list.Dash)
	elif ability == PlayerAbilities.list.JumpAir:
		Abilities.reset(PlayerAbilities.list.JumpAir)
	else:
		EventBus.debug.emit("Ability Reset error for " + str(ability) +" at: "  + str(name) + " at " + str(global_position))
