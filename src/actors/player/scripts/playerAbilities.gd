extends Resource
class_name PlayerAbilities

#TODO: all abilities should get an upgrade and shards/modifires/charms
#TODO: add unlockable skills enum


var unlockedJumpAir: bool = false:
	set(v):
		unlockedJumpAir = v
		if unlockedJumpAir:
			EventBus.playerAbilityUnlocked.emit(list.JumpAir)

var unlockedJumpConsec: bool = false:
	set(v):
		unlockedJumpConsec = v
		if unlockedJumpConsec:
			EventBus.playerAbilityUnlocked.emit(list.JumpConsec)

var unlockedJumpWall: bool = false:
	set(v):
		unlockedJumpWall = v
		if unlockedJumpWall:
			EventBus.playerAbilityUnlocked.emit(list.JumpWall)

var unlockedDashSide: bool = false:
	set(v):
		unlockedDashSide = v
		if unlockedDashSide:
			EventBus.playerAbilityUnlocked.emit(list.DashSide)

var unlockedDashUp: bool = false:
	set(v):
		unlockedDashUp = v
		if unlockedDashUp:
			EventBus.playerAbilityUnlocked.emit(list.DashUp)

var unlockedDashDown: bool = false:
	set(v):
		unlockedDashDown = v
		if unlockedDashDown:
			EventBus.playerAbilityUnlocked.emit(list.DashDown)

var unlockedGlide: bool = false:
	set(v):
		unlockedGlide = v
		if unlockedGlide:
			EventBus.playerAbilityUnlocked.emit(list.Glide)

var unlockedDive: bool = false:
	set(v):
		unlockedDive = v
		if unlockedDive:
			EventBus.playerAbilityUnlocked.emit(list.Dive)

var unlockedGroundPound: bool = false:
	set(v):
		unlockedGroundPound = v
		if unlockedGroundPound:
			EventBus.playerAbilityUnlocked.emit(list.GroundPound)
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
var maxJumpConsec: int = 1

var currentJumpConsec: int = 0:
	set(v):
		currentJumpConsec = clamp(v, 0, maxJumpConsec)

var remainingJumpAir: int = 0:
	set(v):
		remainingJumpAir = clamp(v, 0, maxJumpAir)

var remainingDash: int = 0:
	set(v):
		remainingDash = clamp(v, 0, maxDash)

#FIXME: look at making specific lists for specific funcs
enum list { #TODO: jump flip, etc
	Null,
	All,
	JumpAll,
	JumpAir,
	JumpConsec,
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


func unlock(ability: int, BOOL:bool) -> void:
	if ability == list.All:
		unlockedJumpAir = BOOL
		unlockedJumpConsec = BOOL
		unlockedDashDown = BOOL
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedGlide = BOOL
		unlockedDive = BOOL
		unlockedGroundPound = BOOL
	elif ability == list.JumpAll:
		unlockedJumpAir = BOOL
		unlockedJumpConsec = BOOL
	elif ability == list.JumpAir:
		unlockedJumpAir = BOOL
	elif ability == list.JumpConsec:
		unlockedJumpConsec = BOOL
	elif ability == list.Dash:
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedDashDown = BOOL
	elif ability == list.DashSide:
		unlockedDashSide = BOOL
	elif ability ==  list.DashUp:
		unlockedDashUp = BOOL
	elif ability == list.DashDown:
		unlockedDashDown = BOOL
	elif ability == list.Glide:
		unlockedGlide = BOOL
	elif ability == list.Dive:
		unlockedDive = BOOL
	elif ability == list.GroundPound:
		unlockedGroundPound = BOOL
	else:
		print("Null Ability Unlocked " + str(ability) + " " + str(BOOL))
	
	EventBus.playerAbilitiesUnlock.emit(ability, BOOL)


func can_use(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	elif ability == list.JumpConsec and currentJumpConsec < maxJumpConsec and unlockedJumpConsec:
		return true
	elif ability == list.DashSide and remainingDash > 0 and unlockedDashSide:
		return true
	elif ability == list.DashDown and remainingDash > 0 and unlockedDashDown:
		return true
	elif ability == list.DashUp and remainingDash > 0 and unlockedDashUp:
		return true
	elif ability == list.Glide and unlockedGlide:
		return true
	elif ability == list.Dive and unlockedDive:
		return true
	elif ability == list.GroundPound and unlockedGroundPound:
		return true
	
	return false


func reset(ability: int) -> void:
	if ability == list.All:
		remainingJumpAir = maxJumpAir
		currentJumpConsec = 0
		remainingDash = maxDash
	elif ability == list.JumpAir:
		remainingJumpAir = maxJumpAir
	elif ability == list.JumpConsec:
		currentJumpConsec = 0
	elif ability == list.Dash:
		remainingDash = maxDash
	else:
		print("Null Ability Reset " + str(ability))


func consume(ability: int, amount: int) -> void:
	if ability == list.All:
		remainingJumpAir -= amount
		currentJumpConsec += amount
		remainingDash -= amount
	elif ability == list.JumpAir:
		remainingJumpAir -= amount
	elif ability == list.JumpConsec:
		currentJumpConsec += amount
	elif ability == list.Dash:
		remainingDash -= amount
	else:
		print("Null Ability Consume " + str(ability)) #TODO: create error log
