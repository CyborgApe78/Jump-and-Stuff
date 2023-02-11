extends Node
class_name PlayerState

#TODO: States: Slide, Roll, Swim, Swim Dash, Grapple, DashWall, DashJump, DashClimb


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
	Fall,
	Glide,
	Dive,
	GroundPound,
	BellySlide,
	WallLand,
	WallSlide,
	WallGrab,
	DashGround,
	DashAir,
	DashUp,
	DashDown,
	DashWall,
	DashClimb,
	DashJump,
	Slide,
	BonkAir,
	BonkGround,
	
	GroundPoundBounce,
	Teleport,
	Die,
	HookShot,
	Swim,
	SwimDash,
	FallDamage,
}

var stateBlacklist: Array = [] #TODO: is this needed
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
