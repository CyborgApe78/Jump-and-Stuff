extends Resource
class_name PlayerAbilities


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

var unlockedDashChain: bool = false:
	set(v):
		unlockedDashChain = v

var unlockedGrappleHook: bool = false:
	set(v):
		unlockedGrappleHook = v

var unlockedBash: bool = false:
	set(v):
		unlockedBash = v

var unlockedGlide: bool = false:
	set(v):
		unlockedGlide = v

var unlockedDive: bool = true:
	set(v):
		unlockedDive = v

var unlockedGroundPound: bool = true:
	set(v):
		unlockedGroundPound = v

var unlockedGroundPoundBounce: bool = false:
	set(v):
		unlockedGroundPoundBounce = v

var unlockedSlide: bool = false:
	set(v):
		unlockedSlide = v

#var unlockedHookShot: bool = false
#var unlockedSwim: bool = false
#var unlockedSwimDash: bool = false
#var unlockedBurrow: bool = false

var maxJumpAir: int = 1
var maxDash: int = 1
var maxDashSide: int = 1
var maxDashUp: int = 1
var maxDashDown: int = 1
var maxDashChain: int = 1
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

var remainingDashSide: int = 0:
	set(v):
		remainingDashSide = clamp(v, 0, maxDashSide)

var remainingDashUp: int = 0:
	set(v):
		remainingDashUp = clamp(v, 0, maxDashUp)

var remainingDashDown: int = 0:
	set(v):
		remainingDashDown = clamp(v, 0, maxDashDown)

var currentDashChain: int = 0:
	set(v):
		currentDashChain = clamp(v, 0, maxDashChain)

enum list {
	Null,
	All,
	JumpAll,
	JumpAir,
	JumpConsec,
	JumpWall,
	JumpGroundPound,
	Dash,
	DashSide,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	DashChain,
	DashGroundPound,
	Slide,
	Glide,
	Dive,
	GroundPound,
	GroundPoundBounce,
	GrappleHook,
	Bash,
	Climb,
	Grab,
	SwimDash,
	Burrow,
	}

enum listAbilityBlock {
	Null,
	All,
	DashSide,
	DashUp,
	DashDown,
	DashJump,
	Slide,
	Dive,
	GrappleHook,
	SwimDash,
	Burrow,
}

enum listAbilityTarget {Null, bash, grappleHook, burrow}


func unlock(ability: int, BOOL:bool) -> void:
	if ability == list.All:
		unlockedJumpAir = BOOL
		unlockedJumpConsec = BOOL
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedDashDown = BOOL
		unlockedDashWall = BOOL
		unlockedDashClimb = BOOL
		unlockedDashJump = BOOL
		unlockedDashChain = BOOL
		unlockedGlide = BOOL
		unlockedDive = BOOL
		unlockedGroundPound = BOOL
		unlockedGroundPoundBounce = BOOL
		unlockedSlide = BOOL
		unlockedGrappleHook = BOOL
		unlockedBash = BOOL
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
	elif ability == list.DashChain:
		unlockedDashChain = BOOL
	elif ability == list.GrappleHook:
		unlockedGrappleHook = BOOL
	elif ability == list.Bash:
		unlockedBash = BOOL
	elif ability == list.Slide:
		unlockedSlide = BOOL
	elif ability == list.Glide:
		unlockedGlide = BOOL
	elif ability == list.Dive:
		unlockedDive = BOOL
	elif ability == list.GroundPound:
		unlockedGroundPound = BOOL
	elif ability == list.GroundPoundBounce:
		unlockedGroundPoundBounce = BOOL
	else:
		EventBus.error.emit("Null Ability Unlocked " + str(ability) + " " + str(BOOL))


func can_use(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	elif ability == list.JumpConsec and currentJumpConsec < maxJumpConsec and unlockedJumpConsec:
		return true
	elif ability == list.DashSide and remainingDashSide > 0 and unlockedDashSide:
		return true
	elif ability == list.DashUp and remainingDashUp > 0 and unlockedDashUp:
		return true
	elif ability == list.DashDown and unlockedDashDown:
		return true
	elif ability == list.DashWall and unlockedDashWall:
		return true
	elif ability == list.DashClimb and unlockedDashClimb:
		return true
	elif ability == list.DashJump and unlockedDashJump:
		return true
	elif ability == list.GrappleHook and unlockedGrappleHook:
		return true
	elif ability == list.Bash and unlockedBash:
		return true
	elif ability == list.Slide and unlockedSlide:
		return true
	elif ability == list.Glide and unlockedGlide:
		return true
	elif ability == list.Dive and unlockedDive:
		return true
	elif ability == list.GroundPound and unlockedGroundPound:
		return true
	elif ability == list.GroundPoundBounce and unlockedGroundPoundBounce:
		return true
	
	return false

func chain_check(ability: int) -> bool:
	if unlockedDashChain and currentDashChain < maxDashChain:
		if ability == list.DashChain:
			return true
		elif ability == list.DashSide and unlockedDashSide:
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
		remainingDashSide = maxDashSide
		remainingDashUp = maxDashUp
		remainingDashDown = maxDashDown
		currentDashChain = 0
	elif ability == list.JumpAir:
		remainingJumpAir = maxJumpAir
	elif ability == list.JumpConsec:
		currentJumpConsec = 0
	elif ability == list.Dash:
		remainingDash = maxDash
		remainingDashSide = maxDashSide
		remainingDashUp = maxDashUp
		remainingDashDown = maxDashDown
	elif ability == list.DashSide:
		remainingDashSide = maxDashSide
	elif ability == list.DashUp:
		remainingDashUp = maxDashUp
	elif ability == list.DashDown:
		remainingDashDown = maxDashDown
	elif  ability == list.DashChain:
		currentDashChain = 0
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
		remainingDashSide -= amount
		remainingDashUp -= amount
		remainingDashDown -= amount
	elif ability == list.DashSide:
		remainingDashSide -= amount
	elif ability == list.DashUp:
		remainingDashUp -= amount
		remainingDashDown -= amount
	elif ability == list.DashDown:
		remainingDashDown -= amount
	elif ability == list.DashChain:
		currentDashChain += amount
	else:
		EventBus.error.emit("Null Ability Consume " + str(ability)) #TODO: create error log
