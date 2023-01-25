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
	GrappleHook,
	Climb,
	Grab,
	Swim,
	SwimDash,
	Burrow,
	}

enum abilityTargetType {Null, grappleHook, burrow}


func unlock_ability(ability: int, BOOL:bool) -> void:
	if ability == list.All:
		unlockedJumpAir = BOOL
		unlockedDashDown = BOOL
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedGlide = BOOL
		unlockedDive = BOOL
		unlockedGroundPound = BOOL
	if ability == list.JumpAir:
		unlockedJumpAir = BOOL
	if ability == list.Dash:
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedDashDown = BOOL
	if ability == list.DashSide:
		unlockedDashSide = BOOL
	if ability ==  list.DashUp:
		unlockedDashUp = BOOL
	if ability == list.DashDown:
		unlockedDashDown = BOOL
	if ability == list.Glide:
		unlockedGlide = BOOL
	if ability == list.Dive:
		unlockedDive = BOOL
	if ability == list.GroundPound:
		unlockedGroundPound = BOOL
	else:
		print("Null Ability Unlocked")
	
	EventBus.emit_signal("playerAbilitiesUnlock", ability, BOOL)


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


func consume(ability: int, amount: int) -> void:
	if ability == list.All:
		remainingJumpAir -= amount
		remainingDash -= amount
	elif ability == list.JumpAir:
		remainingJumpAir -= amount
	elif ability == list.Dash:
		remainingDash -= amount
	else:
		print("Null Ability Consume") #TODO: create error log
