extends PlayerInfo


@export var detector: ShapeCast2D
@export var timerBufferJump: Timer
@export var timerBufferRoll: Timer

@export var jumpModifier: float = 0.5
@export var velocityModifier: float = 1.5

var startingHeight: int
var velocityHop: float


func enter() -> void:
	velocityHop = moveSpeed * velocityModifier
	startingHeight = player.global_position.y
	topSpeed = 0
	
	player.velocity.x = max(velocityHop, abs(player.velocity.x)) * player.facing
	player.velocity.y = jumpVelocity * jumpModifier
	
	player.animPlayer.queue("Belly Slide")


func exit() -> void:
	player.animPlayer.stop()



func physics(delta) -> void:
	player.attempt_horizontal_corner_correction(jumpCornerCorrectionHorizontal, delta)
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	
	if player.moveDirection.x != 0 and player.moveDirection.x != player.facing:
		apply_friction(moveSpeed * 2, delta)
	
	gravity_logic(gravityFall, delta)
	fall_speed_logic(terminalVelocity)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()):
			return State.JumpAir
	if Input.is_action_just_pressed("roll"):
		timerBufferRoll.start()
	if Input.is_action_just_pressed("glide") and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("ground_pound"):
		if abilities.can_use(PlayerAbilities.list.GroundPound): 
			return State.GroundPound
		else:
			return State.Fall
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
	if player.global_position.y > startingHeight: ## leave state when passing starting height
		return State.Dive
	if player.is_on_ceiling(): #TODO: change to bonk
		return State.Fall
	if player.wallDirection != 0:
		if topSpeed > moveSpeed:
			topSpeed = 0
			return State.BonkAir
		else:
			return State.WallSlide
	if player.is_on_floor():
		if !timerBufferRoll.is_stopped():
			EventBus.rumble.emit(0.1, 0.2, 0.2)
			return State.Roll
		else:
			EventBus.rumble.emit(0.2, 0.3, 0.2)
			return State.BellySlide

	return State.Null
