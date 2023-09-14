extends PlayerInfo

#TODO: upgrade for infinte dash

@export var timerDuration: Timer
@export var soundRoll: AudioStreamPlayer #TODO: create sound
@export var soundJetpack: AudioStreamPlayer
@export var particlesSlide: GPUParticles2D
@export var particlesJetpack: GPUParticles2D
@export var detector: ShapeCast2D

@export var duration: float = 0.4


func enter() -> void:
	player.animPlayer.queue("Roll")
	EventBus.playerRolled.emit()
	EventBus.playerDashed.emit()
	
	player.velocityPrevious = player.velocity
	player.velocity.x = player.facing * stats.dashSpeed #TODO: create max velocity, current vs dashVel
	player.ability_mask(CollisionLayers.DashSide, false) #TODO: make own layer to destroy, like melt blocks or something
	
	timers()
	particles(true)
	sounds(true)
	
	player.ability_mask(CollisionLayers.DashSide, false)


func exit() -> void:
	player.animPlayer.stop()
	
	particles(false)
	sounds(false)
	
	player.ability_mask(CollisionLayers.DashSide, true)


func physics(delta) -> void:
	player.move_and_slide_rotation()
	
	if !player.is_on_floor():
		gravity_logic(stats.gravityFall, delta)
	
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	player.animation_speed(.0008) #TODO: tweak number based velocity
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if !detector.is_colliding(): #FIXME: don't want to stop the hop if detecting, if removed player is stuck in wall
		if input.justPressedJump and abilities.can_use(PlayerAbilities.list.JumpRoll):
			return State.RollJump
	if input.justReleasedDash:
		return State.Roll

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > stats.moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if timerDuration.is_stopped():
		if player.is_on_floor():
			abilities.reset(PlayerAbilities.list.Dash)
			return State.Roll
		else:
			return State.Fall
#	if !player.is_on_floor(): #FIXME: won't work, will keep restarting timer. make a bool
#		timerCoyoteJump.stop()

	return State.Null


func timers() -> void:
	timerDuration.wait_time = duration
	timerDuration.start()


func particles(BOOL: bool) -> void:
	particlesSlide.local_coords = BOOL
	particlesSlide.emitting = BOOL
	particlesJetpack.local_coords = BOOL
	particlesJetpack.emitting = BOOL


func sounds(BOOL: bool) -> void:
	if BOOL == true:
#		soundRoll.play()
		soundJetpack.play()
	elif BOOL == false:
#		soundRoll.stop()
		soundJetpack.stop()
