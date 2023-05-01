extends PlayerInfo
#TODO: turn off bonk in settings


var currentBonkTime: float
@export var bonkTime: float = 1.5
@export var bounceBack: int = 400
#TODO:variables for amimation


func enter() -> void:
	EventBus.playerActionAnnounce.emit("Splat")
	consecutive_jump_cancel()
	player.landed()
	player.sounds.bonk.play()
	player.sounds.splat.play()
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
	if abs(player.groundAngle) > 1: ## slide if on slope
		player.velocity.x = move_toward(abs(player.velocity.x), moveSpeed, accelerationGround) * sin(player.groundAngle)
	else: #lookat: letting enviroment effects move
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
