extends Resource
class_name PlayerAbilities

#TODO: all abilities should get an upgrade and shards/modifires/charms
#TODO: add unlockable skills enum


var unlockedJumpAir: bool = false
var unlockedJumpWall: bool = false
var unlockedDashSide: bool = false
var unlockedDashUp: bool = false
var unlockedDashDown: bool = false
var unlockedGlide: bool = false
var unlockedDive: bool = false
var unlockedGroundPound: bool = false
var unlocked: bool = false
#var unlockedDashWall: bool = false
#var unlockedDashJump: bool = false
#var unlockedDashClimb: bool = false
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

var remainingDash: int = 0:
	set(v):
		remainingDash = clamp(v, 0, maxDash)
		EventBus.emit_signal("playerAbilityTrackerCheck")


enum list { #TODO: consec jump, jump flip, etc
	Null,
	All,
	JumpAir,
	JumpWall,
	Dash,
	DashSide,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	Glide,
	Dive,
	GroundPound,
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
		unlockedGlide = true
		unlockedDive = true
		unlockedGroundPound = true
	if ability == list.JumpAir:
		unlockedJumpAir = true
	if ability == list.Dash:
		unlockedDashSide = true
		unlockedDashUp = true
		unlockedDashDown = true
	if ability == list.DashSide:
		unlockedDashSide = true
	if ability ==  list.DashUp:
		unlockedDashUp = true
	if ability == list.DashDown:
		unlockedDashDown = true
	if ability == list.Glide:
		unlockedGlide = true
	if ability == list.Dive:
		unlockedDive = true
	if ability == list.GroundPound:
		unlockedGroundPound = true
	else:
		print("Null Ability Unlocked")


func can_use(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	if ability == list.DashSide and remainingDash > 0 and unlockedDashSide:
		return true
	if ability == list.DashDown and remainingDash > 0 and unlockedDashDown:
		return true
	if ability == list.DashUp and remainingDash > 0 and unlockedDashUp:
		return true
	if ability == list.Glide and unlockedGlide:
		return true
	if ability == list.Dive and unlockedDive:
		return true
	if ability == list.GroundPound and unlockedGroundPound:
		return true
	
	return false


func reset(ability: int) -> void:
	if ability == list.All:
		remainingJumpAir = maxJumpAir
		remainingDash = maxDash
	elif ability == list.JumpAir:
		remainingJumpAir = maxJumpAir
	elif ability == list.Dash:
		remainingDash = maxDash
	elif ability == list.DashSide:
		print("Use Dash Reset")
	elif ability ==  list.DashUp:
		print("Use Dash Reset")
	elif ability == list.DashDown:
		print("Use Dash Reset")
	else:
		print("Null Ability Reset")
