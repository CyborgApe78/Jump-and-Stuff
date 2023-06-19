extends PlayerInfo


@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D

@export var skidDuration: float = 1 #TODO: make speed relavent to skid
var frictionSkid: float = .8 * Util.tileSize
@export var transformTime: float = 0.2
var skidTime: float
@export var skidLockDuration: float = 0.2 
var skidLockTime: float #TODO: make timer



func enter() -> void:
	soundeffect.play()
	#TODO: anim
	particles.restart()
	skidTime = skidDuration
	skidLockTime = skidLockDuration
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT) #TODO: make based on speed as well
	tween.tween_property(player.characterRig, "skew", player.facing * 0.3, transformTime).from_current()
	#TODO: look at speed bend to make dynamic


func exit() -> void:
	soundeffect.stop()
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func physics(delta) -> void:
	skidTime -= delta
	skidLockTime -= delta
	if skidLockTime < 0:
		apply_friction(frictionSkid, delta)
	#TODO: change min(player.velocity.x / skidFrictionModifier, maxSkidSpeed) to velocity to keep from scaling to large


func visual(delta) -> void:
	squash_and_stretch(delta)
	speed_bend(true, moveSpeed, 0.3)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump") and (sign(player.velocity.x) != player.moveDirection.x) and skidLockTime > 0:
		consecutive_jump_cancel()
		return State.JumpFlip
#	if Input.is_action_just_pressed("dash") and abilities.can_use(abilities.list.DashSide):
#		return State.Dash $TODO: make special interaction

	return State.Null


func state_check(delta: float) -> int:
	if skidTime < 0:
		if player.velocity.x == 0:
			return State.Idle
		else:
			player.velocity.x = 0
			return State.Walk


	return State.Null
