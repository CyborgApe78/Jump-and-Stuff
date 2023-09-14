extends Node
class_name InputComponent


var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.ZERO
var moveStrength: Vector2 = Vector2.ZERO
var aimDirection: Vector2 = Vector2.ZERO
var lastAimDirection: Vector2 = Vector2.ZERO
var aimStrength: Vector2 = Vector2.ZERO

var pressedUp: bool = false
var pressedDown: bool = false
var pressedLeft: bool = false
var pressedRight: bool = false
var pressedBash: bool = false
var pressedCrouch: bool = false
var pressedDash: bool = false
var pressedDive: bool = false
var pressedGlide: bool = false
var pressedGrapple: bool = false
var pressedJump: bool = false
var pressedSpin: bool = false

var justPressedUp: bool = false
var justPressedDown: bool = false
var justPressedLeft: bool = false
var justPressedRight: bool = false
var justPressedBash: bool = false
var justPressedCrouch: bool = false
var justPressedDash: bool = false
var justPressedDive: bool = false
var justPressedGlide: bool = false
var justPressedGrapple: bool = false
var justPressedJump: bool = false
var justPressedSpin: bool = false

var justReleasedBash: bool = false
var justReleasedCrouch: bool = false
var justReleasedDash: bool = false
var justReleasedDive: bool = false
var justReleasedJump: bool = false
var justReleasedGlide: bool = false


func _unhandled_input(event: InputEvent) -> void:
	get_move_input()
	get_ability_input()
	get_ability_just_pressed_input()
	get_ability_just_released_input()


func get_move_input() -> void:
	var deadzoneRadius: float = 0.2
	#TODO: make deadzone radius in settings
	var inputStrength: = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	var aimInput = Input.get_vector("aim_left", "aim_right", "aim_up", "aim_down")
	
	moveStrength = inputStrength if inputStrength.length() > deadzoneRadius else Vector2.ZERO
	aimStrength = aimInput if aimInput.length() > deadzoneRadius else Vector2.ZERO
	
	moveDirection = moveStrength.round()
	aimDirection = aimStrength.round()
	
	if moveDirection.x != 0:
		lastMoveDirection.x = moveDirection.x
	if moveDirection.y != 0:
		lastMoveDirection.y = moveDirection.y


func get_ability_input() -> void:
	if Input.is_action_pressed("move_up"):
		pressedUp= true
	if Input.is_action_just_released("move_up"):
		pressedUp = false
	
	if Input.is_action_pressed("move_down"):
		pressedDown = true
	if Input.is_action_just_released("move_down"):
		pressedDown = false
	
	if Input.is_action_pressed("move_left"):
		pressedLeft = true
	if Input.is_action_just_released("move_left"):
		pressedLeft = false
	
	if Input.is_action_pressed("move_right"):
		pressedRight = true
	if Input.is_action_just_released("move_right"):
		pressedRight = false
	
	if Input.is_action_pressed("bash"):
		pressedBash = true
	if Input.is_action_just_released("bash"):
		pressedBash = false
	
	if Input.is_action_pressed("crouch"):
		pressedCrouch = true
	if Input.is_action_just_released("crouch"):
		pressedCrouch = false
	
	if Input.is_action_pressed("dash"):
		pressedDash = true
	if Input.is_action_just_released("dash"):
		pressedDash = false
	
	if Input.is_action_pressed("dive"):
		pressedDive = true
	if Input.is_action_just_released("dive"):
		pressedDive = false
	
	if Input.is_action_pressed("glide"):
		pressedGlide = true
	if Input.is_action_just_released("glide"):
		pressedGlide = false
	
	if Input.is_action_pressed("grapple_hook"):
		pressedGrapple = true
	if Input.is_action_just_released("grapple_hook"):
		pressedGrapple = false
	
	if Input.is_action_pressed("jump"):
		pressedJump = true
	if Input.is_action_just_released("jump"):
		pressedJump = false
	
	if Input.is_action_pressed("spin"):
		pressedJump = true
	if Input.is_action_just_released("spin"):
		pressedJump = false


func get_ability_just_pressed_input() -> void:
	if Input.is_action_just_pressed("move_up"):
		justPressedUp = true
		await get_tree().process_frame
		justPressedUp = false
	
	if Input.is_action_just_pressed("move_down"):
		justPressedDown = true
		await get_tree().process_frame
		justPressedDown = false
	
	if Input.is_action_just_pressed("move_left"):
		justPressedLeft = true
		await get_tree().process_frame
		justPressedLeft = false
	
	if Input.is_action_just_pressed("move_right"):
		justPressedRight = true
		await get_tree().process_frame
		justPressedRight = false
	
	if Input.is_action_just_pressed("bash"):
		justPressedBash = true
		await get_tree().process_frame 
		justPressedBash = false
	
	if Input.is_action_just_pressed("crouch"):
		justPressedCrouch = true
		await get_tree().process_frame 
		justPressedCrouch = false
	
	if Input.is_action_just_pressed("dash"):
		justPressedDash = true
		await get_tree().process_frame 
		justPressedDash = false
	
	if Input.is_action_just_pressed("dive"):
		justPressedDive = true
		await get_tree().process_frame 
		justPressedDive = false
	
	if Input.is_action_just_pressed("glide"):
		justPressedGlide = true
		await get_tree().process_frame 
		justPressedGlide = false
	
	if Input.is_action_just_pressed("grapple_hook"):
		justPressedGrapple = true
		await get_tree().process_frame 
		justPressedGrapple = false
	
	if Input.is_action_just_pressed("jump"):
		justPressedJump = true
		await get_tree().process_frame
		justPressedJump = false
	
	if Input.is_action_just_pressed("spin"):
		justPressedSpin = true
		await get_tree().process_frame 
		justPressedSpin = false


func get_ability_just_released_input() -> void:
	if Input.is_action_just_released("bash"):
		justReleasedBash = true
		await get_tree().process_frame
		justReleasedBash = false
	
	if Input.is_action_just_released("crouch"):
		justReleasedCrouch = true
		await get_tree().process_frame
		justReleasedCrouch = false
	
	if Input.is_action_just_released("dash"):
		justReleasedDash = true
		await get_tree().process_frame
		justReleasedDash = false
	
	if Input.is_action_just_released("dive"):
		justReleasedDive = true
		await get_tree().process_frame
		justReleasedDive = false
	
	if Input.is_action_just_released("jump"):
		justReleasedJump = true
		await get_tree().process_frame
		justReleasedJump = false
	
	if Input.is_action_just_released("glide"):
		justReleasedGlide = true
		await get_tree().process_frame
		justReleasedGlide = false
