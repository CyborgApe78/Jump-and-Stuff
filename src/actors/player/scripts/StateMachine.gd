extends Node

#TODO: create subcatorgies to orgainize 

@onready var states = {
	PlayerState.State.Spawn: $Spawn,
	PlayerState.State.Die: $Die,
	PlayerState.State.Idle: $Idle,
	PlayerState.State.Walk: $Walk,
	PlayerState.State.Skid: $Skid,
	PlayerState.State.Crouch: $Crouch,
	PlayerState.State.Jump: $Jump,
	PlayerState.State.JumpAir: $JumpAir,
	PlayerState.State.JumpConsec: $JumpConsec,
	PlayerState.State.JumpLong: $JumpLong,
	PlayerState.State.JumpCrouch: $JumpCrouch,
	PlayerState.State.JumpFlip: $JumpFlip,
	PlayerState.State.JumpApex: $JumpApex,
	PlayerState.State.JumpWall: $JumpWall,
	PlayerState.State.JumpGroundPound: $JumpGroundPound,
	PlayerState.State.Fall: $Fall,
	PlayerState.State.Glide: $Glide,
	PlayerState.State.Dive: $Dive,
	PlayerState.State.DiveHop: $DiveHop,
	PlayerState.State.GroundPound: $GroundPound,
	PlayerState.State.GroundPoundLand: $GroundPoundLand,
	PlayerState.State.GroundPoundBounce: $GroundPoundBounce,
	PlayerState.State.BellySlide: $BellySlide,
	PlayerState.State.BellySlideHop: $BellySlideHop,
	PlayerState.State.BellySlideDash: $BellySlideDash,
	PlayerState.State.WallSlide: $WallSlide,
	PlayerState.State.DashGround: $DashGround,
	PlayerState.State.DashAir: $DashAir,
	PlayerState.State.DashUp: $DashUp,
	PlayerState.State.DashDown: $DashDown,
	PlayerState.State.DashWall: $DashWall,
	PlayerState.State.DashClimb: $DashClimb,
	PlayerState.State.DashJump: $DashJump,
	PlayerState.State.DashGroundPound: $DashGroundPound,
	PlayerState.State.GrappleHook: $GrappleHook,
	PlayerState.State.BashAim: $BashAim,
	PlayerState.State.Bash: $Bash,
	PlayerState.State.Slide: $Slide,
	PlayerState.State.Roll: $Roll,
	PlayerState.State.RollJump: $RollJump,
	PlayerState.State.RollDash: $RollDash,
	PlayerState.State.Swim: $Swim,
	PlayerState.State.BonkAir: $BonkAir,
	PlayerState.State.BonkGround: $BonkGround,
	
#	PlayerState.State.Teleport: $Teleport,
#	PlayerState.State.Shinespark: $Shinespark,
#	PlayerState.State.SwimDash: $SwimDash,
}

var currentState: PlayerState
var previousState: PlayerState
var currentStateName: String
var previousStateName: String

@onready var player: Player = owner
@export var stats: StatsComponent
@export var velocity: VelocityComponent
@export var input: InputComponent


#func _ready() -> void:
#	EventBus.playerDied.connect(player_died)
#	EventBus.playerBounced.connect(bounce)
#	EventBus.playerTeleported.connect(player_teleported)

func change_state(newState: int) -> void:
	if currentState:
		currentState.exit()
		previousState = currentState
		previousStateName = previousState.name
		player.previousState = previousState.name
		#TODO: make black list check
	
	currentState = states[newState]
	currentState.enter()
	currentStateName = currentState.name
	player.currentStateName = currentState.name
	
	EventBus.debugState.emit(currentStateName + " from " + previousStateName)
	EventBus.playerStateChange.emit(currentStateName + " from " + previousStateName)


func init() -> void:
	for child in get_children():
		if child is PlayerState:
			child.player = player
			child.stats = stats
			child.velocity = velocity
			child.input = input

	change_state(PlayerState.State.Spawn)

func handle_input(event: InputEvent) -> void:
	var newState = currentState.handle_input(event)
	if newState != PlayerState.State.Null:
		change_state(newState)


func physics(delta) -> void:
	currentState.physics(delta)


func state_check(delta) -> void:
	var newState = currentState.state_check(delta)
	if newState != PlayerState.State.Null:
		change_state(newState)


func visual(delta) -> void:
	currentState.visual(delta)


func sound(delta) -> void:
	currentState.sound(delta)


func player_died() -> void:
	change_state(PlayerState.State.Die)
