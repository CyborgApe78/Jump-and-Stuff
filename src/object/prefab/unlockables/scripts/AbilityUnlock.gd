extends UnlockableBase


@onready var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
@export var ability: PlayerAbilities.list
var blockColor: Color
@export var unlock: bool = true

func _ready() -> void:
	super._ready()
	block_color()
	body_entered.connect(_on_unlock_entered)


func block_color() -> void:
	if ability == PlayerAbilities.list.All:
		modulate = AbilityColor.allColor
	elif ability == PlayerAbilities.list.JumpAir:
		modulate = AbilityColor.jumpColor
	elif ability == PlayerAbilities.list.DashSide:
		modulate = AbilityColor.dashSideColor
	elif ability == PlayerAbilities.list.DashUp:
		modulate = AbilityColor.dashUpColor
	elif ability == PlayerAbilities.list.DashDown:
		modulate = AbilityColor.dashDownColor
#	elif ability == PlayerAbilities.list.Grapple:
#		blockColor = AbilityColor.grappleColor
	elif ability == PlayerAbilities.list.SwimDash:
		modulate = AbilityColor.swimDashColor
	elif ability == PlayerAbilities.list.Burrow:
		modulate = AbilityColor.burrowColor
#	elif ability == PlayerAbilities.list.Pogo:
#		blockColor = AbilityColor.pogoColor
#	elif ability == PlayerAbilities.list.Spin:
#		blockColor = AbilityColor.spinColor
#	elif ability == PlayerAbilities.list.Bash:
#		blockColor = AbilityColor.bashColor
	else:
		EventBus.error.emit("null color " + str(self.name) + " " + str(global_position))


func _on_unlock_entered(body: Player) -> void:
	if ability == PlayerAbilities.list.JumpAir:
		ability_unlock(PlayerAbilities.list.JumpAir)
	elif ability == PlayerAbilities.list.JumpConsec:
		ability_unlock(PlayerAbilities.list.JumpConsec)
	elif ability == PlayerAbilities.list.JumpWall:
		ability_unlock(PlayerAbilities.list.JumpWall)
	elif ability == PlayerAbilities.list.DashSide:
		ability_unlock(PlayerAbilities.list.DashSide)
	elif ability == PlayerAbilities.list.DashUp:
		ability_unlock(PlayerAbilities.list.DashUp)
	elif ability == PlayerAbilities.list.DashDown:
		ability_unlock(PlayerAbilities.list.DashDown)
	elif ability == PlayerAbilities.list.DashWall:
		ability_unlock(PlayerAbilities.list.Dash)
	elif ability == PlayerAbilities.list.DashClimb:
		ability_unlock(PlayerAbilities.list.DashClimb)
	elif ability == PlayerAbilities.list.DashJump:
		ability_unlock(PlayerAbilities.list.DashJump)
	elif ability == PlayerAbilities.list.Glide:
		ability_unlock(PlayerAbilities.list.Glide)
	elif ability == PlayerAbilities.list.Dive:
		ability_unlock(PlayerAbilities.list.Dive)
	elif ability == PlayerAbilities.list.GroundPound:
		ability_unlock(PlayerAbilities.list.GroundPound)
	elif ability == PlayerAbilities.list.GroundPoundBounce:
		ability_unlock(PlayerAbilities.list.GroundPoundBounce)
	elif ability == PlayerAbilities.list.GrappleHook:
		ability_unlock(PlayerAbilities.list.GrappleHook)
#	elif ability == PlayerAbilities.list.Climb:
#		ability_unlock(PlayerAbilities.list.Climb)
#	elif ability == PlayerAbilities.list.Grab:
#		ability_unlock(PlayerAbilities.list.Grab)
	elif ability == PlayerAbilities.list.SwimDash:
		ability_unlock(PlayerAbilities.list.SwimDash)
	elif ability == PlayerAbilities.list.Burrow:
		ability_unlock(PlayerAbilities.list.Burrow)
	else:
		EventBus.error.emit("Ability Unlock error for " + str(ability) +" at: " + str(name) + " at " + str(global_position))

func ability_unlock(pAbility) -> void:
	Abilities.unlock(pAbility, unlock)
	if unlock:
		announce_ability_unlock(pAbility)


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
		EventBus.debug.emit(str("ability unlock error: ", ability))
