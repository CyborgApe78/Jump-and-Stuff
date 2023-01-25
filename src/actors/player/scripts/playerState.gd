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
	JumpDouble,
	JumpTriple,
	JumpFlip,
	JumpLong,
	JumpCrouch,
	JumpApex,
	Fall,
	Glide,
	Dive,
	GroundPound,
	BellySlide,
	DashGround,
	DashAir,
	DashUp,
	DashDown,
	BonkAir,
	BonkGround,
	
	GroundPoundBounce,
	Teleport,
	Die,
	JumpWall,
	DashWall,
	DashClimb,
	DashJump,
	WallSlide,
	WallGrab,
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
