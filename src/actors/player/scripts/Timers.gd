extends Node

#TODO: move more timers to here

@export var coyoteJump: Timer
@export var coyoteJumpWall: Timer
@export var consecutiveJump: Timer
@export var bufferJump: Timer


func _ready() -> void:
	## sets timers to one shot ##
#	for timers in get_children():
#		timers.one_shot = true
	
	consecutiveJump.timeout.connect(consecutive_jump_timeout)

func consecutive_jump_timeout() -> void:
	EventBus.playerConsecutiveJump.emit()
