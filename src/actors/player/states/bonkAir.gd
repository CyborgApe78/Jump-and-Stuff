extends PlayerInfo


@export_group("Connections")
@export var soundBonk: AudioStreamPlayer
@export var particles: GPUParticles2D

@export_group("")
@export var bonkTime: float = 1.5
@export var bounceBack: int = 400

var currentBonkTime: float
var landed: bool


func enter() -> void:
	EventBus.playerActionAnnounce.emit("Bonk")
	EventBus.rumble.emit(0.5, 0.7, 0.4)
	consecutive_jump_cancel()
	landed = false
	soundBonk.play()
	currentBonkTime = bonkTime
	player.velocity.x = bounceBack * -player.facing
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "scale", Vector2(0.2, 0.8), .05)


func exit() -> void:
	velocity.topSpeed = 0


func physics(delta) -> void:
	player.move_and_slide()
	
	velocity.gravity_logic(stats.gravityFall, delta)
	velocity.fall_speed_logic(stats.terminalVelocity)
	if player.is_on_floor():
		currentBonkTime -= delta
		player.velocity = Vector2.ZERO
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(player.characterRig, "scale", Vector2(1, 1), .5)
		if !landed:
			player.landed()
			landed = true
	
	align_to_ground()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:

	return State.Null


func state_check(delta: float) -> int:
	if currentBonkTime < 0:
		return State.Idle

	return State.Null
