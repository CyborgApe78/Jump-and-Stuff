extends PlayerInfo

#TODO: set up dash amount/duration check
#export (float, 0 , 0.3, 0.05) var dashJumpTime: float = .17
#onready var dashJumpTimer: Timer = $DashJumpTimer
#export (float, 0 , 0.3, 0.05) var dashJumpRefreshTime: float = .22
#onready var dashJumpRefreshTimer: Timer = $DashJumpRefreshTimer
#var superJump: bool = false

@export var distance: float = 4.0
@export var duration: float = 0.3
@onready var dashSpeed: float = distance / duration #TODO: based off movespeed
#TODO: upgrade to become like bullet from mario, 3 quick, multi way
#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump

var dashTimer: float
var saveTriple: bool

func enter() -> void:
	saveTriple = true if player.jumpedDouble else false
	dashTimer = duration
	player.particles.dash.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * ((moveSpeed * 1.2) / duration)


func exit() -> void:
	player.particles.dash.emitting = false
	#TODO:
#	if player.is_on_floor(): 
#		if superJump: ## dash jump with dash count reset
#			player.dashCDTimer.stop()
##			EventBus.emit_signal("error", "ultra jump")
#		else:## dash jump 
#			player.consume_ability(PlayerAbilities.list.DashAir, 1)
#			if !dashJumpTimer.is_stopped():
##				EventBus.emit_signal("error", "early jump")
#				player.velocityPlayer.x = player.velocityPlayer.x/4
##			else:
##				EventBus.emit_signal("error", "super jump")
#
#	elif !player.is_on_floor():
#		player.consume_ability(PlayerAbilities.list.DashAir, 1)
#		if player.moveDirection.x != 0:
#			player.velocityPlayer.x = player.velocityPrevious.x
#
#	player.animPlayer.stop()
#	superJump = false


func physics(delta) -> void:
	player.move_and_slide()
	dashTimer -= delta
	player.timers.consecutiveJump.start()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): 
		return consecutive_jump_logic()
	
#	if Input.is_action_just_pressed("jump"):
#		if dashJumpRefreshTimer.is_stopped():
#			superJump = true
#		else:
#			superJump = false
#		return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if dashTimer < 0:
		if player.is_on_floor():
			return State.Walk
		else:
			return State.Fall

	return State.Null
