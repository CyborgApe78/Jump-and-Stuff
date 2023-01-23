extends PlayerInfo
#TODO: Roll state
#TODO: further dive if coming from ground pound
@onready var rollTimer: Timer = $RollPressed
@onready var fallTimer: Timer = $FallTimeMax

@export var rollTime: float = 0.5
@export var diveSpeedMultiplier: float = 1.6
@export var transformTime: float = 0.05
@export var fallTimeTillBonk: float = 1.2


func enter() -> void:
	rollTimer.wait_time = rollTime
	fallTimer.wait_time = fallTimeTillBonk
	neutral_move_direction_logic()
	fallTimer.start()
	print(max(moveSpeed * diveSpeedMultiplier, abs(player.velocity.x)))
	player.velocity.x = max(moveSpeed * diveSpeedMultiplier, abs(player.velocity.x)) * player.facing  ## dive at dive speed or current velocity, whichever's high
	player.velocity.y = -100
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(player.characterRotate, "rotation_degrees", 45 * player.facing, transformTime).from(0)
	tween.tween_property(player.characterCollision, "rotation_degrees", 45 * player.facing, transformTime).from(0)


func exit() -> void:
	pass


func physics(delta: float) -> void:
	player.attempt_vertical_corner_correction(jumpCornerCorrectionVertical, delta)
	
	player.move_and_slide()
	gravity_logic(gravityFall, delta)
	fall_speed_logic(terminalVelocity)
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	squash_and_stretch(delta)
	align_to_ground()


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("roll"):
		rollTimer.start()
	if Input.is_action_just_pressed("ground pound"):
		return State.GroundPound
	if Input.is_action_just_pressed("dash") and abilities.can_use_ability(abilities.list.DashSide):
		return State.DashAir

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if player.is_on_floor():
		player.sounds.land.play()
		#TODO: sound
		player.landed()
#		if !rollTimer.is_stopped():
#			return State.Roll
		if fallTimer.is_stopped():
			return State.BonkGround
		else:
			var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
			tween.tween_property(player.characterRotate, "rotation_degrees", 0, transformTime).from_current()
			tween.tween_property(player.characterCollision, "rotation_degrees", 0, transformTime).from_current()
			return State.BellySlide

	return State.Null
