extends Resource
class_name PlayerAbilities


var unlockedJumpAir: bool = false
var unlockedJumpConsec: bool = false
var unlockedJumpFlip: bool = false
var unlockedJumpLong: bool = false
var unlockedJumpCrouch: bool = false
var unlockedJumpGroundPound: bool = false
var unlockedJumpWall: bool = false
var unlockedJumpRoll: bool = false
var unlockedJumpBelly: bool = false

var unlockedDashSide: bool = false
var unlockedDashUp: bool = false
var unlockedDashDown: bool = false
var unlockedDashGround: bool = false ## Unlimited dash on ground
var unlockedDashWall: bool = false
var unlockedDashClimb: bool = false
var unlockedDashJump: bool = false
var unlockedDashGroundPound: bool = false
var unlockedDashRoll: bool = false #TODO: Create State
var unlockedDashBelly: bool = false
var unlockedDashChain: bool = false

var unlockedSlide: bool = false #TODO: Rework State
var unlockedGroundPound: bool = false
var unlockedGroundPoundBounce: bool = false
var unlockedWallGrab: bool = false
var unlockedGrappleHook: bool = false
var unlockedBash: bool = false
var unlockedSpin: bool = false #TODO: Create State
var unlockedRoll: bool = false
var unlockedBurrow: bool = false #TODO: Create State
var unlockedGlide: bool = false
var unlockedDive: bool = false
var unlockedSwimDash: bool = false

var maxJumpAir: int = 1
var maxDash: int = 1
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

var currentDashChain: int = 0:
	set(v):
		currentDashChain = clamp(v, 0, maxDashChain)

enum list {
	Null,
	All,
	JumpAir,
	JumpFlip,
	JumpLong,
	JumpCrouch,
	JumpConsec,
	JumpGroundPound,
	JumpWall,
	JumpRoll,
	JumpBelly,
	Dash,
	DashSide,
	DashUp,
	DashDown,
	DashGround,
	DashWall,
	DashClimb,
	DashJump,
	DashChain,
	DashGroundPound,
	DashRoll,
	DashBelly,
	Slide,
	GroundPound,
	GroundPoundBounce,
	WallGrab,
	GrappleHook,
	Bash,
	Spin,
	Roll,
	Burrow,
	Glide,
	Dive,
	SwimDash,
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
		unlockedJumpFlip = BOOL
		unlockedJumpLong = BOOL
		unlockedJumpCrouch = BOOL
		unlockedJumpGroundPound = BOOL
		unlockedJumpWall = BOOL
		unlockedJumpRoll = BOOL
		unlockedJumpBelly = BOOL
		unlockedJumpConsec = BOOL
		unlockedDashSide = BOOL
		unlockedDashUp = BOOL
		unlockedDashDown = BOOL
		unlockedDashGround = BOOL
		unlockedDashWall = BOOL
		unlockedDashClimb = BOOL
		unlockedDashJump = BOOL
		unlockedDashGroundPound = BOOL
		unlockedDashBelly = BOOL
		unlockedDashChain = BOOL
		unlockedSlide = BOOL
		unlockedGroundPound = BOOL
		unlockedGroundPoundBounce = BOOL
		unlockedWallGrab = BOOL
		unlockedGrappleHook = BOOL
		unlockedBash = BOOL
		unlockedSpin = BOOL
		unlockedRoll = BOOL
		unlockedBurrow = BOOL
		unlockedGlide = BOOL
		unlockedDive = BOOL
		unlockedSwimDash = BOOL
	elif ability == list.JumpAir:
		unlockedJumpAir = BOOL
	elif ability == list.JumpFlip:
		unlockedJumpFlip = BOOL
	elif ability == list.JumpLong:
		unlockedJumpLong = BOOL
	elif ability == list.JumpCrouch:
		unlockedJumpCrouch = BOOL
	elif ability == list.JumpGroundPound:
		unlockedJumpGroundPound = BOOL
	elif ability == list.JumpWall:
		unlockedJumpWall = BOOL
	elif ability == list.JumpRoll:
		unlockedJumpRoll = BOOL
	elif ability == list.JumpBelly:
		unlockedJumpBelly = BOOL
	elif ability == list.JumpConsec:
		unlockedJumpConsec = BOOL
	elif ability == list.DashSide:
		unlockedDashSide = BOOL
	elif ability == list.DashUp:
		unlockedDashUp = BOOL
	elif ability == list.DashDown:
		unlockedDashDown = BOOL
	elif ability == list.DashGround:
		unlockedDashGround = BOOL
	elif ability == list.DashWall:
		unlockedDashWall = BOOL
	elif ability == list.DashClimb:
		unlockedDashClimb = BOOL
	elif ability == list.DashJump:
		unlockedDashJump = BOOL
	elif ability == list.DashGroundPound:
		unlockedDashGroundPound = BOOL
	elif ability == list.DashRoll:
		unlockedDashRoll = BOOL
	elif ability == list.DashBelly:
		unlockedDashBelly = BOOL
	elif ability == list.DashChain:
		unlockedDashChain = BOOL
	elif ability == list.Slide:
		unlockedSlide = BOOL
	elif ability == list.GroundPound:
		unlockedGroundPound = BOOL
	elif ability == list.GroundPoundBounce:
		unlockedGroundPoundBounce = BOOL
	elif ability == list.WallGrab:
		unlockedWallGrab = BOOL
	elif ability == list.GrappleHook:
		unlockedGrappleHook = BOOL
	elif ability == list.Bash:
		unlockedBash = BOOL
	elif ability == list.Spin:
		unlockedSpin = BOOL
	elif ability == list.Roll:
		unlockedRoll = BOOL
	elif ability == list.Burrow:
		unlockedBurrow = BOOL
	elif ability == list.Glide:
		unlockedGlide = BOOL
	elif ability == list.Dive:
		unlockedDive = BOOL
	elif ability == list.SwimDash:
		unlockedSwimDash = BOOL
	else:
		EventBus.error.emit("Null Ability Unlocked " + str(ability) + " " + str(BOOL))


func can_use(ability: int) -> bool:
	if ability == list.JumpAir and remainingJumpAir > 0 and unlockedJumpAir:
		return true
	elif ability == list.JumpFlip and unlockedJumpFlip:
		return true
	elif ability == list.JumpLong and unlockedJumpLong:
		return true
	elif ability == list.JumpCrouch and unlockedJumpCrouch:
		return true
	elif ability == list.JumpGroundPound and unlockedJumpGroundPound:
		return true
	elif ability == list.JumpWall and unlockedJumpWall:
		return true
	elif ability == list.JumpRoll and unlockedJumpRoll:
		return true
	elif ability == list.JumpBelly and unlockedJumpBelly:
		return true
	elif ability == list.JumpConsec and currentJumpConsec < maxJumpConsec and unlockedJumpConsec:
		return true
	elif ability == list.DashSide and remainingDash > 0 and unlockedDashSide:
		return true
	elif ability == list.DashUp and remainingDash > 0 and unlockedDashUp:
		return true
	elif ability == list.DashDown and remainingDash > 0 and unlockedDashDown:
		return true
	elif ability == list.DashGround and unlockedDashGround:
		return true
	elif ability == list.DashWall and unlockedDashWall:
		return true
	elif ability == list.DashClimb and unlockedDashClimb:
		return true
	elif ability == list.DashJump and unlockedDashJump:
		return true
	elif ability == list.DashGroundPound and unlockedDashGroundPound:
		return true
	elif ability == list.DashRoll and unlockedDashRoll:
		return true
	elif ability == list.DashBelly and unlockedDashBelly:
		return true
	elif ability == list.Slide and unlockedSlide:
		return true
	elif ability == list.GroundPound and unlockedGroundPound:
		return true
	elif ability == list.GroundPoundBounce and unlockedGroundPoundBounce:
		return true
	elif ability == list.WallGrab and unlockedWallGrab:
		return true
	elif ability == list.GrappleHook and unlockedGrappleHook:
		return true
	elif ability == list.Bash and unlockedBash:
		return true
	elif ability == list.Spin and unlockedSpin:
		return true
	elif ability == list.Roll and unlockedRoll:
		return true
	elif ability == list.Burrow and unlockedBurrow:
		return true
	elif ability == list.Glide and unlockedGlide:
		return true
	elif ability == list.Dive and unlockedDive:
		return true
	elif ability == list.SwimDash and unlockedSwimDash:
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
		currentDashChain = 0
	elif ability == list.JumpAir:
		remainingJumpAir = maxJumpAir
	elif ability == list.JumpConsec:
		currentJumpConsec = 0
	elif ability == list.Dash:
		remainingDash = maxDash
	elif ability == list.DashChain:
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
	elif ability == list.DashChain:
		currentDashChain += amount
	else:
		EventBus.error.emit("Null Ability Consume " + str(ability))
