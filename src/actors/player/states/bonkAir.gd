extends PlayerInfo


@export var soundBonk: AudioStreamPlayer
@export var particles: GPUParticles2D

var currentBonkTime: float
@export var bonkTime: float = 1.5
@export var bounceBack: int = 400
var landed: bool


func enter() -> void:
	EventBus.playerActionAnnounce.emit("Bonk")
	consecutive_jump_cancel()
	landed = false
	soundBonk.play()
	currentBonkTime = bonkTime
	player.velocity.x = bounceBack * -player.facing #TODO: get wall detection
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(player.characterRig, "scale", Vector2(0.2, 0.8), .05) #FIXME: not always working


func exit() -> void:
	topSpeed = 0


func physics(delta) -> void:
	player.move_and_slide()
	
	gravity_logic(gravityFall, delta)
	fall_speed_logic(terminalVelocity)
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
