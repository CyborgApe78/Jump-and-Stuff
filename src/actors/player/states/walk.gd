extends PlayerInfo

#TODO: add nuetral input

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var soundeffect: AudioStreamPlayer

@export var skidPercent: float = 1.2

var skidding: bool = false


func enter() -> void:
	player.animPlayer.queue("Walk")
	skidding = false


func exit() -> void:
	player.animPlayer.stop()
	soundeffect.stop()
	player.animPlayer.speed_scale = 1


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > stats.moveSpeed * skidPercent and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = player.lastMoveDirection.x * 1
	elif player.moveDirection.x != 0 and abs(player.velocity.x) < stats.moveSpeed:
		player.velocity.x = VelEq.apply_acceleration(player.velocity.x, stats.moveSpeed, stats.accelerationGround, player.moveStrength.x, delta)
	elif player.moveDirection.x == 0:
		player.velocity.x = VelEq.apply_friction(player.velocity.x, stats.frictionGround, delta)
	elif abs(player.velocity.x) >= stats.moveSpeed:
		momentum_logic(stats.moveSpeed, true)
	
	if player.moveDirection.x == 0 and (player.ledgeLeft or player.ledgeRight): ## stops on ledge w/o input
		#TODO:make it so you have to be facing the ledge 
		player.velocity.x = 0
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)


func visual(delta) -> void:
	player.animation_speed(.004)
	player.facing_logic()
	speed_bend(false)
	align_to_ground()
	


func sound(delta: float) -> void:
		pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		return consecutive_jump_logic()
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if input.pressedCrouch: 
		return State.Crouch
	if player.inWater:
		return State.Swim
	if skidding:
		return State.Skid
	if !player.is_on_floor():
		timerCoyoteJump.start()
		return State.Fall
	if player.velocity.x == 0:
		return State.Idle
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		if input.pressedCrouch and abilities.can_use(PlayerAbilities.list.JumpLong): ## not sure if do anything since long jump checks for this
			return State.JumpLong
		else:
			return consecutive_jump_logic()
	if dashBufferState != State.Null:
		if dashBufferState == State.DashGround and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashGround
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp

	return State.Null

