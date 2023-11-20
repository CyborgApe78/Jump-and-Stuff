extends PlayerInfo


@export_group("Connections")
@export var timerAim: Timer
@export var timerInvincibility: Timer
@export var hitbox: Area2D

@export_group("")
@export var timeInvincible: float = 0.8
@export var aim: float = 0.8


func enter() -> void:
	hitbox.monitorable = false ## make player invincible
	player.global_position = player.targetBash.global_position
	EventBus.playerBashed.emit()
	EventBus.timeFreeze.emit(true)
	player.velocity = Vector2.ZERO
	timers()


func exit() -> void:
	EventBus.timeFreeze.emit(false)
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
	if input.justReleasedBash:
		return State.Bash

	return State.Null


func state_check(delta: float) -> int:
	if timerAim.is_stopped():
		return State.Bash

	return State.Null


func timers() -> void:
	timerAim.wait_time = aim
	timerAim.start()
