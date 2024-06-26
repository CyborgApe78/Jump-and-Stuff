extends Node
class_name PlayerState


enum State {
	Null,
	Spawn,
	Idle,
	Walk,
	Skid,
	Crouch,
	CrouchWalk,
	Jump,
	JumpAir,
	JumpConsec,
	JumpFlip,
	JumpLong,
	JumpCrouch,
	JumpCrouchCharged,
	JumpApex,
	JumpWall,
	JumpGroundPound,
	Fall,
	Glide,
	Dive,
	DiveHop,
	GroundPound,
	GroundPoundLand,
	GroundPoundBounce,
	BellySlide,
	BellySlideHop,
	BellySlideDash,
	WallSlide,
	WallGrab,
	DashGround,
	DashAir,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	GrappleHook,
	BashAim,
	Bash,
	Slide,
	SlideButt,
	Roll,
	RollJump,
	RollDash,
	Swim,
	SwimDash,
	Grind,
	Swing,
	BonkAir,
	BonkGround,
	
	Teleport,
	Die,
}

var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func handle_input(event: InputEvent) -> int:
	return State.Null

func visual(delta: float) -> void:
	pass

func sound(delta: float) -> void:
	pass

func physics(delta: float) -> void:
	pass

func state_check(delta: float) -> int:
	return State.Null
