extends UnlockableBase


@onready var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
@export var ability: PlayerAbilities.list
@export var unlock: bool = true

func _ready() -> void:
	super._ready()
	body_entered.connect(_on_unlock_entered)


func _on_unlock_entered(body: Player) -> void:
	Abilities.unlock(ability, unlock)
	if unlock:
		announce_ability_unlock(ability)


func announce_ability_unlock(pAbility: int) -> void:
	if pAbility == PlayerAbilities.list.All:
		EventBus.announce.emit(str("The whole enchilada unlocked"))
	elif pAbility == PlayerAbilities.list.JumpAir:
		EventBus.announce.emit(str("Air Jump Unlocked"))
	elif pAbility == PlayerAbilities.list.JumpConsec:
		EventBus.announce.emit(str("Consec Jump Unlocked"))
	elif pAbility == PlayerAbilities.list.JumpWall:
		EventBus.announce.emit(str("Wall Jump Unlocked"))
	elif pAbility == PlayerAbilities.list.DashSide:
		EventBus.announce.emit(str("Dash Unlocked"))
	elif pAbility == PlayerAbilities.list.DashUp:
		EventBus.announce.emit(str("Dash Up Unlocked"))
	elif pAbility == PlayerAbilities.list.DashDown:
		EventBus.announce.emit(str("Dash Down Unlocked"))
	elif pAbility == PlayerAbilities.list.Glide:
		EventBus.announce.emit(str("Glide Unlocked"))
	elif pAbility == PlayerAbilities.list.Dive:
		EventBus.announce.emit(str("Dive Unlocked"))
	else:
		EventBus.announce.emit(str("Needs flavor text for unlocking"))
