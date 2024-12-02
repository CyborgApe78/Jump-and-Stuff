class_name InputManager extends Node


@export_group("Connections")
@export var player: Player
@export var timerBufferJump: Timer
@export var timerCoyote: Timer
@export var timerSemisolid: Timer

@export_group("")
@export_range(0.0, 2.0, 0.05) var _jumpBufferTime: float = 0.1
@export_range(0.0, 2.0, 0.05) var _coyoteTime: float = 0.1
@export_range(0.0, 2.0, 0.05) var _semisolidTime: float = 0.1

var moveDirection: Vector2 = Vector2.ZERO
var lastMoveDirection: Vector2 = Vector2.RIGHT
var moveStrength: Vector2 = Vector2.ZERO

var canBufferJump: bool = false
var canCoyoteJump: bool = false


func _ready() -> void:
	set_timers()


func _unhandled_input(_event: InputEvent) -> void:
	get_move_input()
	
	if Input.is_action_just_pressed("jump") and not player.is_on_floor():
		canBufferJump = true
		timerBufferJump.start()


func get_move_input() -> void:
	var deadzoneRadius: float = 0.2
	#TODO: make deadzone radius in settings
	var inputStrength: = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	
	moveStrength = inputStrength if inputStrength.length() > deadzoneRadius else Vector2.ZERO
	
	moveDirection = moveStrength.round()
	
	if moveDirection.x != 0:
		lastMoveDirection.x = moveDirection.x
	if moveDirection.y != 0:
		lastMoveDirection.y = moveDirection.y


func leave_ground() -> void:
	timerCoyote.start()
	canCoyoteJump = true


func set_timers() -> void:
	timerBufferJump.wait_time = _jumpBufferTime
	timerCoyote.wait_time = _coyoteTime


func _on_coyote_t_imer_timeout() -> void:
	canCoyoteJump = false


func _on_buffer_timer_timeout() -> void:
	canBufferJump = false
