extends PlayerInfo


#LOOKAT: make it more like cape from mario
@export var timerBufferJump: Timer
@export var timerCoyoteJumpWall: Timer

var duration: float = 0.3
var dashDirection: int
@export var particles: GPUParticles2D
@export var soundJetpack: AudioStreamPlayer


func enter() -> void:
	EventBus.playerDashed.emit()
	soundJetpack.play()
	player.animPlayer.queue("Dash Side Air")
	dashDirection = -player.wall_detection(30)
	player.velocityPrevious = player.velocity
	particles.local_coords = true
	particles.emitting = true
	player.velocity.y = 0
	player.velocity.x = dashDirection * dashVelocity
	player.characterRig.scale.x = dashDirection
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	soundJetpack.stop()
	player.animPlayer.stop()
	particles.local_coords = false
	particles.emitting = false
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x
	player.ability_mask(CollisionLayers.DashSide, true)

func physics(delta) -> void:
	player.move_and_slide()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	if !soundJetpack.playing:
		soundJetpack.play()


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		timerCoyoteJumpWall.start()
		if abilities.can_use(PlayerAbilities.list.JumpAir) and !(player.detectorGroundLeft.is_colliding() or player.detectorGroundRight.is_colliding()): #TODO: ground check to use buffer instead of double jump
			return State.JumpAir
		else:
			timerBufferJump.start()
			return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use(PlayerAbilities.list.DashSide):
		abilities.consume(PlayerAbilities.list.DashSide, 1)
		return State.DashAir
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall(): 
		if !timerCoyoteJumpWall.is_stopped():
			return State.JumpWall #TODO: create JumpReflect
		elif topSpeed > moveSpeed: #TODO: add back affter timer
			topSpeed = 0
			return State.BonkAir

	return State.Null
