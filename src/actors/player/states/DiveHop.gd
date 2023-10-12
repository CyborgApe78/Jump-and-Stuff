extends PlayerInfo
## Boosted distance after ground pound

@export var detector: ShapeCast2D
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer

@export var jumpModifier: float = 0.5
@export var velocityModifier: float = 1.5

var startingHeight: int
var velocityHop: float
var diveDirection: int

func enter() -> void:
	diveDirection = input.moveDirection.x if input.moveDirection.x != 0 else player.facing # lets player switch directions quickly in air
	velocityHop = stats.moveSpeed * velocityModifier
	startingHeight = player.global_position.y
	velocity.topSpeed = 0
	
	player.velocity.x = max(velocityHop, abs(player.velocity.x)) * diveDirection
	player.facing_logic(diveDirection)
	player.velocity.y = stats.diveVelocity
	
	player.animPlayer.queue("Belly Slide")


func exit() -> void:
	player.animPlayer.stop()



func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(stats.jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(stats.jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if input.moveDirection.x != 0 and input.moveDirection.x != player.facing:
		velocity.apply_friction(stats.moveSpeed * 2, delta)
	
	if player.velocity.y < 0:
		velocity.gravity_logic(stats.gravityDiveFloat, delta)
	else:
		velocity.gravity_logic(stats.gravityFall, delta)
	velocity.fall_speed_logic(stats.terminalVelocity)
	
	velocity.track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.justPressedJump:
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(ground.detectorGroundLeft.is_colliding() or ground.detectorGroundRight.is_colliding()):
			return State.JumpAir
	if input.justPressedDive and abilities.can_use(PlayerAbilities.list.Roll):
		timerBufferRoll.start()
	if input.justPressedGlide and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if input.justPressedCrouch and abilities.can_use(PlayerAbilities.list.GroundPound):
		return State.GroundPound
	if input.justPressedDash:
		dash_pressed_buffer()
	if input.justPressedGrapple and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if input.justPressedBash and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Dive
	if player.is_on_ceiling(): #TODO: change to bonk
		return State.Fall
	if wall.wallDirection != 0:
		if velocity.topSpeed > stats.moveSpeed:
			velocity.topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor() and abilities.can_use(PlayerAbilities.list.Roll): #FIXME: this should be with timer below
		EventBus.playerLanded.emit() #TODO: added landed when changed to squishing player instead of anim
#		player.landed()
		if !timerBufferRoll.is_stopped():
			EventBus.rumble.emit(0.1, 0.2, 0.2)
			return State.Roll
		else:
			EventBus.rumble.emit(0.2, 0.3, 0.2)
			return State.BellySlide
	if dashBufferState != State.Null:
		if dashBufferState == State.DashAir and abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashAir
		if dashBufferState == State.DashUp and abilities.can_use(PlayerAbilities.list.DashUp):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashUp
		if dashBufferState == State.DashDown and abilities.can_use(PlayerAbilities.list.DashDown):
			abilities.consume(PlayerAbilities.list.Dash, 1)
			return State.DashDown

	return State.Null
