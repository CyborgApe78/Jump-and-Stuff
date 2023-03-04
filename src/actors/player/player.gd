extends Actor
class_name  Player


@export var stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")
@export var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

@export var animPlayer: AnimationPlayer
@export var sm: Node
@export var characterRig: Node2D
@export var characterRotate: Node2D
@export var characterCollision: CollisionShape2D
@export var eyes: Node2D
@export var body: Node2D
@export var particles: Node2D
@export var timers: Node
@export var sounds: Node
@export var detectorGroundLeft: RayCast2D
@export var detectorGroundRight: RayCast2D
@export var wallRaycastLeft: ShapeCast2D
@export var wallRaycastRight: ShapeCast2D

var eyeDirection: int = 1 #TODO: randomizer on spawn
var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.ZERO
var moveStrength: Vector2 = Vector2.ZERO
var aimDirection: Vector2 = Vector2.ZERO
var lastAimDirection: Vector2 = Vector2.ZERO
var aimStrength: Vector2 = Vector2.ZERO
var groundAngle: float
var velocityPrevious: Vector2 = Vector2.ZERO
var velocityRotated: Vector2 = Vector2.ZERO

var neutralMoveDirection: bool = false

var wallDirection: int = 0 
var lastWallDirection: int = 0
var facing: int = 1 #FIXME: better facing logic

var jumped: bool
var ledgeLeft: bool
var ledgeRight: bool

var currentStateName

var groundColor: Color = Color.BLACK


func _ready() -> void:
	sm.init()
	default_ability_mask()
	EventBus.playerConsecutiveJump.connect(consecutive_jump_cancel)
	EventBus.teleportPlayer.connect(teleport_player)


func _unhandled_input(event: InputEvent) -> void:
	sm.handle_input(event)


func _physics_process(delta: float) -> void:
	sm.physics(delta)
	sm.state_check(delta)

	get_move_input()
	facing_logic()
	get_slope_angle()
	
	if is_on_floor(): #TODo: create is grounded using floor raycasts
		ledge_detection()
	
	EventBus.debugVelocity.emit(velocity.round())
	EventBus.debug.emit(Input.get_vector("move_left", "move_right", "move_up", "move_down"))
	EventBus.debug2.emit(Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")))


func _process(delta: float) -> void:
	sm.visual(delta)
	sm.sound(delta)


func move_and_slide_rotation() -> void:
	set_up_direction(-transform.y)
	velocity = velocity.rotated(rotation)
	move_and_slide()
	velocity = velocity.rotated(-rotation)


func get_move_input() -> void:
	var deadzoneRadius: float = 0.2
	#TODO: make deadzone radius in settings
	var inputStrength: = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	#TODO: need to add input get_vector
	var aimInput = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	
	moveStrength = inputStrength if inputStrength.length() > deadzoneRadius else Vector2.ZERO
	aimStrength = aimInput if aimInput.length() > deadzoneRadius else Vector2.ZERO
	
	moveDirection = moveStrength.round()
	aimDirection = aimStrength.round()
	
	if moveDirection != Vector2.ZERO:
		lastMoveDirection = moveDirection
	
	aimDirection = aimDirection.round()


func facing_logic():
	#TODO: need to be able to send variables
	if moveDirection.x == 1 and eyeDirection == -1:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(eyes, "position", Vector2(0, eyes.position.y), 0.2).from_current()
		eyeDirection = 1
		particles.scale.x = 1
		facing = eyeDirection
	if moveDirection.x == -1  and eyeDirection == 1:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(eyes, "position", Vector2(-8, eyes.position.y), 0.2).from_current() #TODO: eyes should be own functiun
		eyeDirection = -1
		particles.scale.x = -1
		facing = eyeDirection


func ledge_detection() -> void:
	if is_on_floor() and !detectorGroundLeft.is_colliding():
		ledgeLeft = true
	else:
		ledgeLeft = false
	
	if is_on_floor() and !detectorGroundRight.is_colliding():
		ledgeRight = true
	else:
		ledgeRight = false

func attempt_vertical_corner_correction(amount: int, delta) -> void:
	if test_move(global_transform, Vector2(velocity.x * delta, 0)): 
		#FIXME: need to check if angled ceiling and cancel
		for i in range(1, amount*2+1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(0, i * j / 2)), Vector2(velocity.x * delta, 0)):
					translate(Vector2(0, i * j / 2))
					if velocity.y * j < 0: velocity.y = 0
					EventBus.helperUsed.emit(Util.helper.cornerCorrectionVertical)
					return


func attempt_horizontal_corner_correction(amount: int, delta) -> void:
	if test_move(global_transform, Vector2(0, velocity.y * delta)):
		for i in range(1, amount*2+1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(i * j / 2, 0)), Vector2(0, velocity.y * delta)):
					translate(Vector2(i * j / 2, 0))
					if velocity.x * j < 0: velocity.x = 0
					EventBus.helperUsed.emit(Util.helper.cornerCorrectionHorizontal)
					return


func consecutive_jump_cancel() -> void: 
	jumped = false
	timers.consecutiveJump.stop()
	abilities.reset(PlayerAbilities.list.JumpConsec)


func landed() -> void:
	abilities.reset(PlayerAbilities.list.JumpAir)
	abilities.reset(PlayerAbilities.list.Dash)
#	if get_last_slide_collision() != null:
#			groundColor = get_last_slide_collision().get_collider().color #FIXME: crash if doesn't have color
	particles.land.restart()


func get_slope_angle() -> void:
	if detectorGroundLeft.is_colliding() or detectorGroundRight.is_colliding(): ## angles the player to the ground
		var leftAngle: float = detectorGroundLeft.get_collision_normal().angle() + PI/2
		var rightAngle: float = detectorGroundRight.get_collision_normal().angle() + PI/2
		
		if !detectorGroundRight.is_colliding():
			groundAngle = leftAngle
		if !detectorGroundLeft.is_colliding():
			groundAngle = rightAngle
		else:
			groundAngle = (leftAngle + rightAngle)/2
	else:
		groundAngle = 0
	
	if rad_to_deg(abs(groundAngle)) > 45:
		groundAngle = 0


func wall_detection(length: int = 5) -> int:
	if wallRaycastLeft.target_position.x != -length:
		wallRaycastLeft.target_position.x = -length
	if wallRaycastRight.target_position.x != length:
		wallRaycastRight.target_position.x = length
	
	wallRaycastLeft.force_shapecast_update()
	wallRaycastRight.force_shapecast_update()
	
	if  wallRaycastLeft.is_colliding() and wallRaycastRight.is_colliding():
		wallDirection = 0
		return 0
	elif wallRaycastLeft.is_colliding():
		wallDirection = -1
		return -1
	elif wallRaycastRight.is_colliding():
		wallDirection = 1
		return 1
	
	if wallDirection != 0:
		lastWallDirection = wallDirection
	
	return 0


func _on_dash_chain_timeout() -> void:
	particles.jumpTriple.restart()
	#TODO: create own particles


func ability_mask(layer: int, BOOL: bool) -> void:
	set_collision_mask_value(layer, BOOL)


func default_ability_mask() -> void:
	ability_mask(CollisionLayers.DashSide, true)
	ability_mask(CollisionLayers.DashUp, true)
	ability_mask(CollisionLayers.DashDown, true)
	ability_mask(CollisionLayers.DashJump, true)


func teleport_player(location: Vector2) -> void:
	global_position = location
	velocity = Vector2.ZERO
	#TODO: dificulty setting for healing on teleport
