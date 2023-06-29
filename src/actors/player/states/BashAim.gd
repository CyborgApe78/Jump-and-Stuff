extends PlayerInfo


@export var timerAim: Timer
@export var timerInvincibility: Timer
@export var hitbox: Area2D

@export var timeInvincible: float = 0.8
@export var aim: float = 0.8


func enter() -> void:
	hitbox.monitorable = false ## make player invincible
	player.global_position = player.targetBash.global_position
	EventBus.playerBashed.emit()
	player.velocity = Vector2.ZERO
	timers()


func exit() -> void:
	timerInvincibility.wait_time = timeInvincible
	timerInvincibility.start()
	hitbox.monitorable = true


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
