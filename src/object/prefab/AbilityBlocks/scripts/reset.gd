extends AbilityBlockBase

func _ready() -> void:
	body_entered.connect(_on_reset_entered)

func _on_reset_entered(body: Player) -> void:
	if ability == PlayerAbilities.listUse.All:
		Abilities.reset(PlayerAbilities.listUse.All)
	elif ability == PlayerAbilities.listChain.DashSide:
		Abilities.reset(PlayerAbilities.listChain.DashSide)
	elif ability == PlayerAbilities.listChain.DashUp:
		Abilities.reset(PlayerAbilities.listChain.DashUp)
	elif ability == PlayerAbilities.listChain.DashDown:
		Abilities.reset(PlayerAbilities.listChain.DashDown)
	elif ability == PlayerAbilities.listUse.Dash:
		Abilities.reset(PlayerAbilities.listUse.Dash)
	elif ability == PlayerAbilities.listUse.JumpAir:
		Abilities.reset(PlayerAbilities.listUse.JumpAir)
	else:
		EventBus.error.emit("Ability Reset error for " + str(ability) +" at: " + str(name) + " at " + str(global_position))
