extends PlayerInfo


@export_group("Connections")
@export var timerCoyoteJump: Timer
@export var timerConsecutiveJump: Timer
@export var dashJumpTimer: Timer
@export var dashJumpRefreshTimer: Timer
@export var durationTimer: Timer
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer

@export_group("")
@export var dashJumpTime: float = 0.17
@export var dashJumpRefreshTime: float = 0.22
@export var duration: float = 0.3


var isJumping: bool = false
var saveTriple: bool
var dashInput: int


func enter() -> void:
	@warning_ignore("incompatible_ternary")
	dashInput = input.aimBackup.x if input.aimBackup != Vector2.ZERO else player.facing
	abilities.consume(PlayerAbilities.listUse.Dash, 1)
	soundJetpack.play()
	EventBus.playerDashed.emit()
	player.velocityPrevious = player.velocity
	saveTriple = true if abilities.currentJumpConsec > 1 else false
	timers()
	player.animPlayer.queue("Dash Side")
	particles.local_coords = true
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = dashInput * stats.dashSpeed
	player.facing_logic(dashInput)
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	if !isJumping:
		player.velocity.x = player.velocityPrevious.x
	isJumping = false
	player.ability_mask(CollisionLayers.DashSide, true)


func physics(delta) -> void:
	player.move_and_slide_rotation()
	timerConsecutiveJump.start()
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump and (player.is_on_floor() or !timerCoyoteJump.is_stopped()): #leave ground, but stil can jump
		if !timerCoyoteJump.is_stopped():
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Coyote Jump")
		isJumping = true
		if dashJumpRefreshTimer.is_stopped(): ## dash jump with dash count reset
			abilities.reset(PlayerAbilities.listUse.Dash)
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
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim
		
		##LOOKAT: add other dashes and wall jump

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and velocity.topSpeed > stats.moveSpeed:
		velocity.topSpeed = 0
		return State.BonkAir
	if durationTimer.is_stopped():
		if player.is_on_floor():
			abilities.reset(PlayerAbilities.listUse.Dash)
			return State.Walk
		else:
			return State.Fall

	return State.Null


func timers() -> void:
	dashJumpTimer.wait_time = dashJumpTime
	dashJumpRefreshTimer.wait_time = dashJumpRefreshTime
	durationTimer.wait_time = duration
	dashJumpTimer.start()
	dashJumpRefreshTimer.start()
	durationTimer.start()


func _on_dash_jump_refresh_timeout() -> void:
	pass
