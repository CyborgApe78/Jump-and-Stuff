extends PlayerInfo

#TODO: set up dash amount/duration check
@export var duration: float = 0.3 #TODO: add to player stats to pull from
@onready var durationTimer: Timer = $Duration
@export var distance: float = 4.0
@onready var dashSpeed: float = distance / duration #TODO: based off movespeed
#TODO: upgrade to become like bullet from mario, 3 quick, multi way
#TODO: conserve consec jump, make challenge were 2 jump, dash under then triple jump


func enter() -> void:
	abilities.remainingDashSide -= 1
	player.velocityPrevious = player.velocity
	durationTimer.wait_time = duration
	durationTimer.start()
	player.particles.dash.emitting = true #TODO: use signals to call
	player.velocity.y = 0
	player.velocity.x = player.facing * ((moveSpeed) / duration)


func exit() -> void:
	player.particles.dash.emitting = false #TODO: use signals to call
	
#		player.consume_ability(PlayerAbilities.list.DashAir, 1)  #TODO
	if player.moveDirection.x != 0:
		player.velocity.x = player.velocityPrevious.x


func physics(delta) -> void:
	player.move_and_slide()
	player.timers.consecutiveJump.start()
	track_top_speed(player.velocity.x)


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("jump"):
		#TODO: air jump check
		return State.Fall
	if Input.is_action_just_pressed("glide")  and abilities.can_use_ability(PlayerAbilities.list.Glide):
		return State.Glide
	if Input.is_action_just_pressed("dive")  and abilities.can_use_ability(PlayerAbilities.list.Dive):
		return State.Dive
	if Input.is_action_just_pressed("ground pound") and abilities.can_use_ability(PlayerAbilities.list.GroundPound): 
		return State.GroundPound

	return State.Null


func state_check(delta: float) -> int:
	if player.is_on_wall() and topSpeed > moveSpeed:
		topSpeed = 0
		return State.BonkAir
	if durationTimer.is_stopped():
		if player.is_on_floor():
			return State.Walk
		else:
			return State.Fall

	return State.Null
