extends PlayerInfo

#TODO: turn off hurt box
@export var timerAim: Timer
@export var aim: float = 0.8



func enter() -> void:
	EventBus.playerBashed.emit()
	player.velocity = Vector2.ZERO
	timers()


func exit() -> void:
	pass


func physics(delta) -> void:
	player.move_and_slide()


func visual(delta) -> void:
	pass


func sound(delta: float) -> void:
	pass


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_released("bash"):
		return State.Bash

	return State.Null


func state_check(delta: float) -> int:
	if timerAim.is_stopped():
		return State.Bash

	return State.Null


func timers() -> void:
	timerAim.wait_time = aim
	timerAim.start()
