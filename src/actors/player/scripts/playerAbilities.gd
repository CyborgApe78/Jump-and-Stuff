extends Resource
class_name PlayerAbilities


#TODO: all abilities should get an upgrade and shards/modifires/charms
#TODO: add unlockable skills enum


var unlockedJumpAir: bool = false:
	set(v):
		unlockedJumpAir = v

var unlockedJumpConsec: bool = false:
	set(v):
		unlockedJumpConsec = v

var unlockedJumpWall: bool = false:
	set(v):
		unlockedJumpWall = v

var unlockedDashSide: bool = false:
	set(v):
		unlockedDashSide = v

var unlockedDashUp: bool = false:
	set(v):
		unlockedDashUp = v

var unlockedDashDown: bool = false:
	set(v):
		unlockedDashDown = v

var unlockedDashWall: bool = false:
	set(v):
		unlockedDashWall = v

var unlockedDashClimb: bool = false:
	set(v):
		unlockedDashClimb = v

var unlockedDashJump: bool = false:
	set(v):
		unlockedDashJump = v

var unlockedGlide: bool = false:
	set(v):
		unlockedGlide = v

var unlockedDive: bool = false:
	set(v):
		unlockedDive = v

var unlockedGroundPound: bool = false:
	set(v):
		unlockedGroundPound = v

var unlockedSlide: bool = false:
	set(v):
		unlockedSlide = v

#var unlockedHookShot: bool = false
#var unlockedSwim: bool = false
#var unlockedSwimDash: bool = false
#var unlockedBurrow: bool = false

#TODO: add things like jump, move left, move right for cursed rando
#TODO: change to energy
var maxJumpAir: int = 1
var maxDash: int = 1
var maxDashChain: int = 2
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

var currentDashChain: int = 0:
	set(v):
		currentDashChain = clamp(v, 0, maxDashChain)

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
	Slide,
	Glide,
	Dive,
	GroundPound,
	GrappleHook,
	Climb,
	Grab,
	SwimDash,
	Burrow,
	}


enum abilityTargetType {Null, grappleHook, burrow}


func unlock(ability: int, BOOL:bool) -> void: #TODO: add rest
	if ability == list.All:
		unlockedJumpAir = BOOL
		unlockedJumpConsec = BOOL
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedDashDown = BOOL
		unlockedDashWall = BOOL
		unlockedDashClimb = BOOL
		unlockedDashJump = BOOL
		unlockedGlide = BOOL
		unlockedDive = BOOL
		unlockedGroundPound = BOOL
		unlockedSlide = BOOL
	elif ability == list.JumpAir:
		unlockedJumpAir = BOOL
	elif ability == list.JumpConsec:
		unlockedJumpConsec = BOOL
	elif ability == list.DashSide:
		unlockedDashSide = BOOL
	elif ability ==  list.DashUp:
		unlockedDashUp = BOOL
	elif ability == list.DashDown:
		unlockedDashDown = BOOL
	elif ability == list.DashWall:
		unlockedDashWall = BOOL
	elif ability == list.DashClimb:
		unlockedDashClimb = BOOL
	elif ability == list.DashJump:
		unlockedDashJump = BOOL
	elif ability == list.Slide:
		unlockedSlide = BOOL
	elif ability == list.Glide:
		unlockedGlide = BOOL
	elif ability == list.Dive:
		unlockedDive = BOOL
	elif ability == list.GroundPound:
		unlockedGroundPound = BOOL
	else:
		EventBus.error.emit("Null Ability Unlocked " + str(ability) + " " + str(BOOL))

#TODO: move to PlayerInfo create health and energy variables
func can_use(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	elif ability == list.JumpConsec and currentJumpConsec < maxJumpConsec and unlockedJumpConsec:
		return true
	elif ability == list.DashSide and remainingDash > 0 and unlockedDashSide:
		return true
	elif ability == list.DashUp and remainingDash > 0 and unlockedDashUp:
		return true
	elif ability == list.DashDown and remainingDash > 0 and unlockedDashDown:
		return true
	elif ability == list.DashWall and unlockedDashWall:
		return true
	elif ability == list.DashClimb and unlockedDashClimb:
		return true
	elif ability == list.DashJump and unlockedDashJump:
		return true
	elif ability == list.Slide and unlockedSlide:
		return true
	elif ability == list.Glide and unlockedGlide:
		return true
	elif ability == list.Dive and unlockedDive:
		return true
	elif ability == list.GroundPound and unlockedGroundPound:
		return true
	
	return false

func chain_check(ability: int) -> bool: #TODO: need to remove and reset currentChain
	if currentDashChain < maxDashChain:
		if ability == list.DashSide and unlockedDashSide:
			return true
		elif ability == list.DashUp and unlockedDashUp:
			return true
		elif ability == list.DashDown and unlockedDashDown:
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
		EventBus.error.emit("Null Ability Reset " + str(ability))


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
		EventBus.error.emit("Null Ability Consume " + str(ability)) #TODO: create error log
