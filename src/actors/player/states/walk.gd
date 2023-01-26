extends PlayerInfo

#TODO: break left and right apart
#TODO: get friction from enviroment
#FIXME: pressing up sends to skid

@export var skidPercent: float = 0.8
var skidding: bool = false

func enter() -> void:
	player.particles.walk.emitting = true
	skidding = false


func exit() -> void:
	player.particles.walk.emitting = false
	player.sounds.walk.stop()


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > moveSpeed * skidPercent  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x:
		player.velocity.x = player.lastMoveDirection.x * 1
	elif player.moveDirection.x != 0 and abs(player.velocity.x) < moveSpeed:
		apply_acceleration(accelerationGround, delta)
	elif player.moveDirection.x == 0:
		apply_friction(frictionGround, delta)
	elif player.velocity.x >= moveSpeed:
		momentum_logic(moveSpeed, true)
	
	if player.moveDirection.x == 0 and (player.ledgeLeft or player.ledgeRight): ## stops on ledge w/o input
		player.velocity.x = move_toward(player.velocity.x, 0, frictionGround)
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)


func visual(delta) -> void:
	squash_and_stretch(delta)
	speed_bend(false)
	align_to_ground()


func sound(delta: float) -> void:
	if !player.sounds.walk.playing:
		player.sounds.walk.pitch_scale = randf_range(0.8, 1.2)
		player.sounds.walk.play()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if skidding:
		return State.Skid
	if !player.is_on_floor():
		player.timers.coyoteJump.start()
		return State.Fall
#	if abs(player.velocity.x) > stats.moveSpeed:
#		return State.Turbo
	if player.velocity.x == 0:
		return State.Idle
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashGround:
			dashBufferState = State.Null
			return State.DashGround
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			dashBufferState = State.Null
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			dashBufferState = State.Null
			return State.DashDown

	return State.Null

