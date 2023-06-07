extends PlayerInfo

#TODO: break left and right apart
#TODO: get friction from enviroment
#TODO: add nuetral input

@export var skidPercent: float = 1.2
var skidding: bool = false

func enter() -> void:
	player.animPlayer.queue("Walk")
	skidding = false


func exit() -> void:
	player.animPlayer.stop()
	player.sounds.walk.stop()
	player.animPlayer.speed_scale = 1


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > moveSpeed * skidPercent  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = player.lastMoveDirection.x * 1
	elif player.moveDirection.x != 0 and abs(player.velocity.x) < moveSpeed:
		apply_acceleration(accelerationGround, delta)
	elif player.moveDirection.x == 0: #FIXME: friction is too low if retaining speed over movespeed
		apply_friction(frictionGround, delta)
	elif abs(player.velocity.x) >= moveSpeed:
		momentum_logic(moveSpeed, true)
	
	if player.moveDirection.x == 0 and (player.ledgeLeft or player.ledgeRight): ## stops on ledge w/o input
		player.velocity.x = move_toward(player.velocity.x, 0, frictionGround)
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)
		#TODO: make callable function


func visual(delta) -> void:
	player.animation_speed()
	player.facing_logic()
	speed_bend(false) #TODO: create own bend function
	align_to_ground()
	


func sound(delta: float) -> void: #TODO: move to animPlayer
		pass
#	if !player.sounds.walk.playing:
#		player.sounds.walk.pitch_scale = randf_range(0.8, 1.2)
#		player.sounds.walk.play()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("slide"):
		return State.Slide
	if Input.is_action_just_pressed("speed_boost"): #TODO: add unlock
		return State.SpeedBoost
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.inWater:
		return State.Swim
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
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashGround
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.DashUp, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.DashDown, 1)
			return State.DashDown

	return State.Null

