extends PlayerInfo

#TODO: get friction from enviroment
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
	if abs(player.velocity.x) > moveSpeed * skidPercent  and player.moveDirection.x != 0 and (sign(player.velocity.x) != player.moveDirection.x):
		skidding = true
	elif player.velocity.x != 0 and sign(player.velocity.x) != player.lastMoveDirection.x: ## kill velocity when changing directions
		player.velocity.x = player.lastMoveDirection.x * 1
	elif player.moveDirection.x != 0 and abs(player.velocity.x) < moveSpeed:
		player.velocity.x = VelEq.apply_acceleration(player.velocity.x, moveSpeed, accelerationGround, player.moveStrength.x, delta)
	elif player.moveDirection.x == 0:
		player.velocity.x = VelEq.apply_friction(player.velocity.x, frictionGround, delta)
	elif abs(player.velocity.x) >= moveSpeed:
		momentum_logic(moveSpeed, true)
	
	if player.moveDirection.x == 0 and (player.ledgeLeft or player.ledgeRight): ## stops on ledge w/o input
		#TODO:make it so you have to be facing the ledge 
		#TODO: setting to turn off
		player.velocity.x = 0
		EventBus.helperUsed.emit(Util.helper.stopOnLedge)


func visual(delta) -> void:
	player.animation_speed(.004)
	player.facing_logic()
	speed_bend(false) #TODO: create own bend function
	align_to_ground()
	


func sound(delta: float) -> void:
		pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_pressed("crouch"): 
		return State.Crouch
	if Input.is_action_just_pressed("jump"):
		return consecutive_jump_logic()
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashGround
	if Input.is_action_just_pressed("slide"):
		return State.Slide
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.inWater:
		return State.Swim
	if skidding:
		return State.Skid
	if !player.is_on_floor():
		timerCoyoteJump.start()
		return State.Fall
#	if abs(player.velocity.x) > stats.moveSpeed:
#		return State.Turbo
	if player.velocity.x == 0:
		return State.Idle
	if !timerBufferJump.is_stopped():
		timerBufferJump.stop()
		EventBus.helperUsed.emit(Util.helper.bufferJump)
		return consecutive_jump_logic()

	return State.Null

