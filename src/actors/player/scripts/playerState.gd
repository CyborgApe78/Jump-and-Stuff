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
	GroundPound,
	GroundPoundLand,
	GroundPoundBounce,
	BellySlide,
	WallLand,
	WallSlide,
	WallGrab,
	DashGround,
	DashAir,
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
	Swim,
	SwimDash,
	BonkAir,
	BonkGround,
	
	Teleport,
	Die,
}

var stateBlacklist: Array = [] #TODO: figure way to block states during dungeons
var statePrevious: int #TODO: find way to set
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
