extends PlayerInfo

#FIXME: not liking this anymore, change to something else
#TODO: add block break indicator

@export var dashJumpTime: float = 0.17
@onready var dashJumpTimer: Timer = $DashJump
@export var dashJumpRefreshTime: float = 0.22
@onready var dashJumpRefreshTimer: Timer = $DashJumpRefresh
@export var duration: float = 0.3
@export var durationTimer: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

var isJumping: bool = false
var saveTriple: bool

#TODO: reverse ultra jump
#TODO: save triple or more for super/ultra


func enter() -> void:
	soundJetpack.play()
	GameStats.dashSide += 1
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	timers()
	player.animPlayer.queue("Dash Side") #TODO: own animation if walking, use the animation tree
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = player.facing * dashVelocity
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.emitting = false
	if !isJumping:
		player.velocity.x = player.velocityPrevious.x
	isJumping = false
	player.ability_mask(CollisionLayers.DashSide, true)


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
			EventBus.playerActionAnnounce.emit("Ultra Jump")
			return consecutive_jump_logic()
		else: ## dash jump 
			if dashJumpTimer.is_stopped(): 
				EventBus.playerActionAnnounce.emit("Super Jump")
				return consecutive_jump_logic()
			else:
				EventBus.playerActionAnnounce.emit("Early Jump")
				player.velocity.x = player.velocity.x/4
				return State.Jump
		#TODO: add chain dash
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

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


func  timers() -> void:
	dashJumpTimer.wait_time = dashJumpTime
	dashJumpRefreshTimer.wait_time = dashJumpRefreshTime
	durationTimer.wait_time = duration
	dashJumpTimer.start()
	dashJumpRefreshTimer.start()
	durationTimer.start()


func _on_dash_jump_refresh_timeout() -> void:
	pass
	#TODO: indicator for Ultra Jump
