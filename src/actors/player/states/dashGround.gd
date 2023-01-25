extends PlayerInfo

#TODO: set up dash amount/duration check
@export var dashJumpTime: float = 0.17
@onready var dashJumpTimer: Timer = $DashJump
@export var dashJumpRefreshTime: float = 0.22
@onready var dashJumpRefreshTimer: Timer = $DashJumpRefresh
@export var duration: float = 0.3 #TODO: add to player stats to pull from
@onready var durationTimer: Timer = $Duration

var isJumping: bool = false
var saveTriple: bool

@export var distance: float = 4.0
@onready var dashSpeed: float = distance / duration #TODO: based off movespeed
#TODO: upgrade to become like bullet from mario, 3 quick, multi way
#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump


func enter() -> void:
	abilities.remainingDashSide -= 1
	player.velocityPrevious = player.velocity
	saveTriple = true if player.jumpedDouble else false
	dashJumpTimer.wait_time = dashJumpTime
	dashJumpRefreshTimer.wait_time = dashJumpRefreshTime
	durationTimer.wait_time = duration
	dashJumpTimer.start()
	dashJumpRefreshTimer.start()
	durationTimer.start()
	player.particles.dash.emitting = true #TODO: use signals to call
	player.velocity.y = 0
	player.velocity.x = player.facing * ((moveSpeed) / duration)


func exit() -> void:
	player.particles.dash.emitting = false #TODO: use signals to call
	
	if !isJumping:
		player.velocity.x = player.velocityPrevious.x
#
#	player.animPlayer.stop()
	isJumping = false


func physics(delta) -> void:
	player.move_and_slide()
	player.timers.consecutiveJump.start()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): 
		isJumping = true
		if dashJumpRefreshTimer.is_stopped(): ## dash jump with dash count reset
			abilities.reset(PlayerAbilities.list.Dash)
#			player.dashCDTimer.stop()  #TODO
			EventBus.emit_signal("playerInfo", "Ultra Jump")
			return consecutive_jump_logic()
		else: ## dash jump 
			if dashJumpTimer.is_stopped(): 
				EventBus.emit_signal("playerInfo", "Super Jump")
				return consecutive_jump_logic()
			else:
				EventBus.emit_signal("playerInfo", "Early Jump")
				player.velocity.x = player.velocity.x/4
				return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if durationTimer.is_stopped():
		if player.is_on_floor():
			return State.Walk
		else:
			return State.Fall

	return State.Null
