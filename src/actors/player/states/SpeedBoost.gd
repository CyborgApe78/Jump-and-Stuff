extends PlayerInfo

#TODO: change from state to more PSpeed inspired. charging up coils
#LOOKAT: need to mess around with wall jumps, need to jump off wall and keep speedboost
#TODO: need a variable to return to speed boost player.speedBoostActive


var skidding: bool = false
@export var speedModifier: float = 2.5
var pMoveSpeed: float


func enter() -> void:
	pMoveSpeed = moveSpeed
	moveSpeed = moveSpeed * speedModifier
	player.animPlayer.queue("Walk")
	skidding = false


func exit() -> void:
	moveSpeed = pMoveSpeed
	player.animPlayer.stop()
	player.sounds.walk.stop()
	player.animPlayer.speed_scale = 1


func physics(delta) -> void:
	player.move_and_slide()
	if abs(player.velocity.x) > pMoveSpeed  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.moveDirection.x != 0 and abs(player.velocity.x) < moveSpeed:
		apply_acceleration(accelerationGround, delta)
	elif player.moveDirection.x == 0:
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
	speed_bend(false) #TODO: move to animation tree
	align_to_ground()


func sound(delta: float) -> void:
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("store_boost"): 
		pass #TODO: store energy
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()
	if Input.is_action_just_pressed("dash"):
		dash_pressed_buffer()
	if Input.is_action_just_pressed("slide"):
		return State.Slide
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if skidding:
		return State.Skid
	if !player.is_on_floor(): #FIXME: need to figure a way to come back to speed boost after leaving ground
		player.timers.coyoteJump.start()
		return State.Fall
	if player.velocity.x == 0:
		return State.Idle
	if !player.timers.bufferJump.is_stopped():
		player.timers.bufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()
	if dashBufferState != State.Null:
		if abilities.can_use(PlayerAbilities.list.DashSide) and dashBufferState == State.DashGround:
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
		if abilities.can_use(PlayerAbilities.list.DashUp) and dashBufferState == State.DashUp:
			abilities.consume(PlayerAbilities.list.DashUp, 1)
			return State.DashUp
		if abilities.can_use(PlayerAbilities.list.DashDown) and dashBufferState == State.DashDown:
			abilities.consume(PlayerAbilities.list.DashDown, 1)
			return State.DashDown

	return State.Null

