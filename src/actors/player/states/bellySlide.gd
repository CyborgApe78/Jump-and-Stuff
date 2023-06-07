extends PlayerInfo


@onready var diveJumpTimer: Timer = $DiveJump

@export var upHillFrictionModifier: float = 2.0
@export var flatGroundFrictionModifier: float = 1.75
@export var downHillAccel: float = 50
@export var transformTime: float = 0.05
@export var diveJumpTime: float = 0.2


func enter() -> void:
	player.sounds.bodySlide.play()
	diveJumpTimer.wait_time = diveJumpTime
	diveJumpTimer.start()
	player.animPlayer.queue("Belly Slide")


func exit() -> void:
	player.sounds.bodySlide.stop()
	player.animPlayer.stop()


func physics(delta) -> void:
	player.move_and_slide()
	player.velocity.y = 1000 #TODO: find better way to snap character
	if rad_to_deg(player.groundAngle) < -1:
		if sign(player.velocity.x) == -1:
			player.velocity.x -= downHillAccel ## Speed up on down hill
		else:
			apply_friction(frictionGround * upHillFrictionModifier, delta) ## Slow on up hill
	if rad_to_deg(player.groundAngle) > 1:
		if sign(player.velocity.x) == 1:
			player.velocity.x += downHillAccel #TODO: make like friction func, need a top speed or make this function
		else:
			apply_friction(frictionGround * upHillFrictionModifier, delta)
	else:
		apply_friction(frictionGround * 1.5, delta)


func visual(delta) -> void:
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO: 
#	if Input.is_action_just_pressed("dive"):
#		return State.BellyHop
	if Input.is_action_just_pressed("jump"):
		if !diveJumpTimer.is_stopped(): # timer to get a special jump
			return State.JumpLong #TODO: special jump
		else:
			player.velocity.x = 0
			return State.Jump

	return State.Null


func state_check(delta: float) -> int:
	if  player.velocity.x == 0:
		if player.moveDirection.x != 0:
			return State.Walk
		else:
			return State.Idle

	return State.Null
