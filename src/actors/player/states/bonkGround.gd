extends PlayerInfo


@export_group("Connections")
@export var soundBonk: AudioStreamPlayer
@export var soundSplat: AudioStreamPlayer

@export_group("")
@export var bonkTime: float = 1.5
@export var bounceBack: int = 400

var currentBonkTime: float


func enter() -> void:
	EventBus.playerActionAnnounce.emit("Splat")
	EventBus.rumble.emit(0.5, 0.7, 0.4)
	consecutive_jump_cancel()
	player.landed()
	soundBonk.play()
	soundSplat.play()
	currentBonkTime = bonkTime
	player.velocity.x = bounceBack * -player.facing #TODO: get wall detection
	var tween = create_tween()
	tween.tween_property(player.characterRig, "scale", Vector2(0.8, 0.2), .2)


func exit() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRig, "scale", Vector2(player.characterRig.scale.x, 1), .2)
	tween.tween_property(player.characterRotate, "rotation", 0, .2)
	player.characterRig.scale.y = 1


func physics(delta) -> void:
	player.move_and_slide()
	
	currentBonkTime -= delta #TODO: make timer
	if abs(ground.groundAngle) > 1: ## slide if on slope
		player.velocity.x = move_toward(abs(player.velocity.x), stats.moveSpeed, stats.accelerationGround) * sin(ground.groundAngle)
	else:
		player.velocity = Vector2.ZERO 



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
