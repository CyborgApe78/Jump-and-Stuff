extends Node

@export_group("Connections")
@export var coyoteJump: Timer
@export var coyoteJumpWall: Timer
@export var consecutiveJump: Timer
@export var bufferJump: Timer
@export var bufferJumpWall: Timer
@export var bufferRoll: Timer
@export var timerSemisolidReset: Timer

@export_group("")
@export var bufferTime: float = 0.1
@export var semisolidResetTime: float = 0.1


func _ready() -> void:
	## sets timers to one shot ##
	for timers in get_children():
		timers.one_shot = true
	
	bufferJump.wait_time = bufferTime
	bufferJumpWall.wait_time = bufferTime
	bufferRoll.wait_time = bufferTime
	timerSemisolidReset.wait_time = semisolidResetTime	
	
	consecutiveJump.timeout.connect(consecutive_jump_timeout)

func consecutive_jump_timeout() -> void:
	EventBus.playerConsecutiveJump.emit()
