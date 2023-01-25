extends PlayerInfo


@export var duration: float = 0.3
@onready var durationTimer: Timer = $Duration


func enter() -> void:
	abilities.remainingDash -= 1
	player.velocityPrevious = player.velocity
	durationTimer.wait_time = duration
	durationTimer.start()
	player.particles.dashUp.emitting = true #TODO: use signals to call
	player.velocity.x = 0
	player.velocity.y = -moveSpeed / duration


func exit() -> void:
	player.particles.dashUp.emitting = false #TODO: use signals to call
	
#	player.consume_ability(PlayerAbilities.list.DashAir, 1)  #TODO
	player.velocity.y = player.velocity.y/4


func physics(delta) -> void:
	player.move_and_slide()


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
	if player.is_on_ceiling(): #TODO: bonk ceiling
		return State.Fall
	if durationTimer.is_stopped():
		return State.Fall

	return State.Null
