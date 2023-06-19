extends PlayerInfo

#TODO: change from state to more PSpeed inspired. charging up coils
#LOOKAT: need to mess around with wall jumps, need to jump off wall and keep speedboost
#TODO: need a variable to return to speed boost player.speedBoostActive

@export var timerCoyoteJump: Timer
@export var timerBufferJump: Timer
@export var soundeffect: AudioStreamPlayer

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
	soundeffect.stop()
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
	player.animation_speed(0.004)
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
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		if player.is_on_floor():
			return State.DashGround
		else:
			return State.DashAir
	if Input.is_action_just_pressed("slide"):
		return State.Slide
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if skidding:
		return State.Skid
	if !player.is_on_floor(): #FIXME: need to figure a way to come back to speed boost after leaving ground
		timerCoyoteJump.start()
		return State.Fall
	if player.velocity.x == 0:
		return State.Idle
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()

	return State.Null

