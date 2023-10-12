extends PlayerInfo


@export var timerDuration: Timer
@export var timerCoyoteJump: Timer
@export var timerCoyoteJumpWall: Timer
@export var timerBufferJump: Timer

@export var duration: float = 0.6

var aimInput: Vector2 #TODO: break aim indicator out so it can be used for other targets


func enter() -> void:
	timers()
	aimInput = input.aimStrength if input.aimStrength != Vector2.ZERO else input.moveStrength
	player.velocity = aimInput * (stats.dashSpeed)
	abilities.reset(PlayerAbilities.list.All)


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if timerCoyoteJump.is_stopped(): #leave ground, but still can jump
			timerCoyoteJump.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Coyote Jump")
			return consecutive_jump_logic()
		elif !timerCoyoteJumpWall.is_stopped() and abilities.can_use(PlayerAbilities.list.JumpWall): #leave wall, but still can jump
			timerCoyoteJumpWall.stop()
			EventBus.helperUsed.emit(Util.helper.coyoteJump)
			EventBus.playerActionAnnounce.emit("Wall Coyote Jump")
			return State.JumpWall
		elif wall.wall_detection(30) != 0 and abilities.can_use(PlayerAbilities.list.JumpWall):
			EventBus.playerActionAnnounce.emit("Near Wall Jump")
			return State.JumpWall
		elif abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
		else:
			timerBufferJump.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Dive):
			return State.Dive 
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if input.justPressedDash:
		dash_pressed_buffer()

	return State.Null


func state_check(delta: float) -> int:
	if timerDuration.is_stopped():
		if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
			return State.Glide
		if !player.is_on_floor():
			if !input.moveDirection == Vector2.ZERO:
				player.velocity = player.velocity / 2
			return State.Fall
	if player.is_on_floor():
		EventBus.playerLanded.emit() #TODO: added landed when changed to squishing player instead of anim
#		player.landed()
		return State.Walk
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			return State.DashDown
	

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()
