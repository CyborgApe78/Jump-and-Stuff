extends Resource
class_name PlayerAbilities

#TODO: all abilities should get an upgrade and shards/modifires/charms
#TODO: add unlockable skills enum


var unlockedJumpAir: bool = false
var unlockedJumpWall: bool = false
var unlockedDashSide: bool = false
var unlockedDashUp: bool = false
var unlockedDashDown: bool = false
#var unlockedDashWall: bool = false
#var unlockedDashJump: bool = false
#var unlockedDashClimb: bool = false
#var unlockedGlide: bool = false
#var unlockedHookShot: bool = false
#var unlockedSwim: bool = false
#var unlockedSwimDash: bool = false
#var unlockedBurrow: bool = false

#TODO: add things like jump, move left, move right for cursed rando

var maxJumpAir: int = 1
var maxDash: int = 1

var remainingJumpAir: int = 0:
	set(v):
		remainingJumpAir = clamp(v, 0, maxJumpAir)

var remainingDashSide: int = 0:
	set(v):
		remainingDashSide = clamp(v, 0, maxDash)
		EventBus.emit_signal("playerAbilityTrackerCheck")

var remainingDashUp: int = 0:
	set(v):
		remainingDashUp = clamp(v, 0, maxDash)
		EventBus.emit_signal("playerAbilityTrackerCheck")

var remainingDashDown: int = 0:
	set(v):
		remainingDashDown = clamp(v, 0, maxDash)
		EventBus.emit_signal("playerAbilityTrackerCheck")

enum list {
	Null,
	All,
	JumpAir,
	JumpWall,
	DashAll,
	DashSide,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	Glide,
	HookShot,
	Climb,
	Grab,
	Swim,
	SwimDash,
	Burrow,
	}

enum abilityTargetType {Null, hookShot, grappleHook, burrow}


func update_stats() -> void:
	remainingJumpAir = maxJumpAir
	remainingDashSide = maxDash
	remainingDashUp = maxDash
	remainingDashDown = maxDash


func unlock_ability(ability: int) -> void:
	if ability == list.All:
		unlockedJumpAir = true
		unlockedDashDown = true
		unlockedDashSide = true
		unlockedDashUp = true
	elif ability == list.JumpAir:
		if unlockedJumpAir == true:
			maxJumpAir = +1
		else:
			unlockedJumpAir = true
	elif ability == list.DashAll:
		#TODO: logic for increased dashes
		unlockedDashSide = true
		unlockedDashUp = true
		unlockedDashDown = true
	elif ability == list.DashSide:
		if unlockedDashSide == true:
			maxDash += 1
		else:
			unlockedDashSide = true
	elif ability ==  list.DashUp:
		unlockedDashUp = true
	elif ability == list.DashDown:
		unlockedDashDown = true
	else:
		print("Null Ability Unlocked")


func can_use_ability(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	if ability == list.DashSide and remainingDashSide > 0 and unlockedDashSide:
		return true
	elif ability == list.DashDown and remainingDashDown > 0 and unlockedDashDown:
		return true
	elif ability == list.DashUp and remainingDashUp > 0 and unlockedDashUp:
		return true
	
	return false
