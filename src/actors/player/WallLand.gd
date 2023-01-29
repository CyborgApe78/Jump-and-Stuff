extends PlayerInfo

@export var coyoteJumpWallTimer: Timer
@export var holdTimer: Timer

var holdTime: float = 0.4
#TODO: redirect previous velocity bassed on aim direction
#TODO: can all wall entraces to this
#TODO: 

## let the player rise till gravity reduces to 0 and wait on timer or input. able to run up wall for a few tiles. 
## holding into wall goes to wall slide

func enter() -> void:
	player.velocityPrevious = player.velocity
	player.velocity.x = 0


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	gravity_logic(gravityFall/4, delta)
	
	if player.velocity.y >= 0:
		player.velocity.y = 0
#		holdTimer.start()


func visual(delta) -> void:
	pass 


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO:
#	if Input.is_action_just_pressed("grab"):
#		return State.JumpReflect
	#TODO: create jump check befor leaving wall
	if Input.is_action_just_pressed("jump"):
		return State.JumpWall
		#JumpWallUp
		#JumpWallDown
		#JumpWallAway
		#JumpWallNuetral
	elif Input.is_action_just_pressed("move_left") and player.lastWallDirection == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		coyoteJumpWallTimer.start()
		return State.Fall
	elif Input.is_action_just_pressed("move_right") and player.lastWallDirection == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		coyoteJumpWallTimer.start()
		return State.Fall
#	if player.moveDirection.x == player.lastWallDirection:
#		return State.WallSlide

	return State.Null


func state_check(delta: float) -> int:
#	if topSpeed > moveSpeed: #TODO: tweak this 
#			topSpeed = 0
#			return State.BonkAir
	if !player.is_on_wall():
		coyoteJumpWallTimer.start()
		return State.Fall
	if player.is_on_floor():
		player.landed()
		player.sounds.land.play() #Lookat: moving sound to landed
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null
