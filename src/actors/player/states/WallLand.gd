extends PlayerInfo

@export var coyoteJumpWallTimer: Timer
@export var holdTimer: Timer

var runUpTile: int = 3
var holdTime: float = 0.5
var noHold: bool
#TODO: redirect previous velocity bassed on aim direction
#TODO: can all wall entraces to this
#TODO: particles

## let the player rise till gravity reduces to 0 and wait on timer or input. able to run up wall for a few tiles. 
## holding into wall goes to wall slide

func enter() -> void:
	player.wall_detection()
	noHold = false
	player.velocityPrevious = player.velocity
	player.velocity.x = 0
	holdTimer.wait_time = holdTime


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()
	
	if !noHold:
		gravity_logic(gravityFall/4, delta)
	
	if player.velocity.y > 0 and !noHold:
		player.velocity.y = 0
		holdTimer.start()
		noHold = true

func visual(delta) -> void:
	pass 


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	#TODO:
#	if Input.is_action_just_pressed("grab"):
#		return State.JumpReflect
	#TODO: create jump check befor leaving wall
	if Input.is_action_pressed("move_up") and player.velocity.y < 0: ## run up the wall at start
		player.velocity.y -= Util.tileSize * runUpTile
	if Input.is_action_just_pressed("jump"):
		return State.JumpWall
		#JumpWallUp
		#JumpWallDown
		#JumpWallAway
		#JumpWallNuetral
	if Input.is_action_just_pressed("move_left") and player.wall_detection() == Vector2.RIGHT.x:
		player.velocity = Vector2(-20,-10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if Input.is_action_just_pressed("move_right") and player.wall_detection() == Vector2.LEFT.x:
		player.velocity = Vector2(20, -10)
		coyoteJumpWallTimer.start()
		return State.Fall
	if Input.is_action_just_pressed("grab"): #TODO: change to another button
		return State.WallGrab
	#TODO: add dive
	if Input.is_action_just_pressed("ground_pound") and abilities.can_use(PlayerAbilities.list.GroundPound): 
		return State.GroundPound
	if Input.is_action_just_pressed("dash"): #TODO:dash wall
		if abilities.can_use(PlayerAbilities.list.DashClimb) and player.moveDirection.y == 1:
			return State.DashClimb
		elif abilities.can_use(PlayerAbilities.list.DashSide):
			abilities.consume(PlayerAbilities.list.DashSide, 1)
			return State.DashAir
#	if player.moveDirection.x == player.lastWallDirection:
#		return State.WallSlide
	if Input.is_action_just_pressed("grapple_hook") and abilities.can_use(PlayerAbilities.list.GrappleHook) and player.targetGrapple != null:
		return State.GrappleHook
	if Input.is_action_just_pressed("bash") and abilities.can_use(PlayerAbilities.list.Bash) and player.targetBash != null:
		return State.BashAim

	return State.Null


func state_check(delta: float) -> int:
#	if topSpeed > moveSpeed: #TODO: tweak this 
#			topSpeed = 0
#			return State.BonkAir
	if noHold and holdTimer.is_stopped(): ## if not holding against the wall, fall
		if player.moveDirection.x == player.wallDirection:
			return State.WallSlide
		else:
			player.velocity = Vector2(20 * -player.facing, -10)
			return State.Fall
	if !player.is_on_wall():
		coyoteJumpWallTimer.start()
		return State.Fall
	if player.is_on_floor():
		player.landed()
		if Input.is_action_pressed("crouch"):
			return State.Crouch
		elif player.velocity.x != 0: 
			return State.Walk
		else:
			return State.Idle

	return State.Null


func _on_hold_timeout() -> void:
	pass # Replace with function body.
