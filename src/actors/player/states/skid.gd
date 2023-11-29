extends PlayerInfo


@export_group("Connections")
@export var soundeffect: AudioStreamPlayer
@export var particles: GPUParticles2D

@export_group("")
@export var skidDuration: float = 1
@export var transformTime: float = 0.2
@export var skidLockDuration: float = 0.2 


var frictionSkid: float = .8 * Util.tileSize
var skidTime: float
var skidLockTime: float


func enter() -> void:
	soundeffect.play()
	particles.restart()
	skidTime = skidDuration
	skidLockTime = skidLockDuration
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "skew", player.facing * 0.3, transformTime).from_current()


func exit() -> void:
	soundeffect.stop()
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "skew", 0, transformTime).from_current()


func physics(delta) -> void:
	skidTime -= delta
	skidLockTime -= delta
	if skidLockTime < 0:
		velocity.apply_friction(frictionSkid, delta)


func visual(delta) -> void:
	speed_bend(true, stats.moveSpeed, 0.3)


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if input.pressedJump and abilities.can_use(PlayerAbilities.list.JumpFlip) and (sign(player.velocity.x) != input.moveDirection.x) and skidLockTime > 0:
		consecutive_jump_cancel()
		return State.JumpFlip
#	if input.justPressedDash and abilities.can_use(abilities.list.DashSide):
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
