extends Node
class_name PlayerState


enum State {
	Null,
	Spawn,
	Idle,
	Walk,
	Skid,
	Crouch,
	Jump,
	JumpAir,
	JumpConsec,
	JumpFlip,
	JumpLong,
	JumpCrouch,
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
	DashGroundPound,
	GrappleHook,
	BashAim,
	Bash,
	Slide,
	Roll,
	RollJump,
	RollDash,
	Swim,
	SwimDash,
	BonkAir,
	BonkGround,
	
	Teleport,
	Die,
}

var statePrevious: int 
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
