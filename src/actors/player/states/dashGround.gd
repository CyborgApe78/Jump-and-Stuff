extends PlayerInfo


@export var dashJumpTime: float = 0.17
@onready var dashJumpTimer: Timer = $DashJump
@export var dashJumpRefreshTime: float = 0.22
@onready var dashJumpRefreshTimer: Timer = $DashJumpRefresh
@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D

var isJumping: bool = false
var saveTriple: bool

#TODO: reverse ultra jump
#TODO: save triple or more for super/ultra


func enter() -> void:
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	dashJumpTimer.wait_time = dashJumpTime
	dashJumpRefreshTimer.wait_time = dashJumpRefreshTime
	durationTimer.wait_time = duration
	dashJumpTimer.start()
	dashJumpRefreshTimer.start()
	durationTimer.start()
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * (dashVelocity / duration)
	player.set_collision_layer_value(CollisionLayers.DashSide, true) #TODO: change to function
	player.set_collision_mask_value(CollisionLayers.DashSide, false)


func exit() -> void:
	particles.emitting = false
	
	if !isJumping:
		player.velocity.x = player.velocityPrevious.x
#
#	player.animPlayer.stop()
	isJumping = false
	
	player.set_collision_layer_value(CollisionLayers.DashSide, false)
	player.set_collision_mask_value(CollisionLayers.DashSide, true)


func physics(delta) -> void:
	player.move_and_slide_rotation()
	player.timers.consecutiveJump.start()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and player.is_on_floor(): 
		isJumping = true
		if dashJumpRefreshTimer.is_stopped(): ## dash jump with dash count reset
			abilities.reset(PlayerAbilities.list.Dash)  #TODO: Change to energy
#			player.dashCDTimer.stop()  #TODO
			EventBus.playerInfo.emit("Ultra Jump")
			return consecutive_jump_logic()
		else: ## dash jump 
			if dashJumpTimer.is_stopped(): 
				EventBus.playerInfo.emit("Super Jump")
				return consecutive_jump_logic()
			else:
				EventBus.playerInfo.emit("Early Jump")
				player.velocity.x = player.velocity.x/4
				return State.Jump
		#TODO: add chain dash

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if durationTimer.is_stopped():
		if player.is_on_floor(): #TODO: if keeping make cd timer
			abilities.reset(PlayerAbilities.list.Dash)  #TODO: Change to energy
			return State.Walk
		else:
			return State.Fall

	return State.Null
