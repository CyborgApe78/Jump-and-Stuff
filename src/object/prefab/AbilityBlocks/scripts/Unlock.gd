extends AbilityBlockBase


@export var unlock: bool = true

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_unlock_entered)


func _on_unlock_entered(body: Player) -> void:
	print("unlcok")
	if ability == PlayerAbilities.list.All:
		Abilities.unlock(PlayerAbilities.list.All, unlock)
	elif ability == PlayerAbilities.list.DashSide:
		Abilities.unlock(PlayerAbilities.list.DashSide, unlock)
	elif ability == PlayerAbilities.list.DashUp:
		Abilities.unlock(PlayerAbilities.list.DashUp, unlock)
	elif ability == PlayerAbilities.list.DashDown:
		Abilities.unlock(PlayerAbilities.list.DashDown, unlock)
	elif ability == PlayerAbilities.list.Dash:
		Abilities.unlock(PlayerAbilities.list.Dash, unlock)
	elif ability == PlayerAbilities.list.JumpAir:
		Abilities.unlock(PlayerAbilities.list.JumpAir, unlock)
	else:
		EventBus.debug.emit("Ability Unlock error for " + str(ability) +" at: "  + str(name) + " at " + str(global_position))
