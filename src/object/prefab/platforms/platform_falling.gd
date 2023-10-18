extends AnimatableBody2D


## When enities lands on platform timer starts then platform falls when reaching zero

signal spawned

@onready var startingPosition: Vector2 = global_position

@export var labelTime: Label
@export var timerReset: Timer
@export var timerFall: Timer
@export var collision: CollisionShape2D

@export_range(0.05, 10, 0.5) var timeReset: float = 1
@export_range(0.05, 10, 0.5) var timeFall: float = 3
@export var fallSpeed: int = 200

enum state {idle, fall}
var currentState


func _ready() -> void:
	timerReset.wait_time = timeReset
	timerFall.wait_time = timeFall
	currentState = state.idle


func _physics_process(delta: float) -> void:
	if !timerFall.is_stopped():
		labelTime.text = str(round(timerFall.time_left))
	match currentState:
		state.idle:
			pass
		state.fall:
			position.y += fallSpeed * delta



func reset() -> void:
	currentState = state.idle
	global_position = startingPosition
	collision.set_deferred("disabled", false)
	visible = true
	spawned.emit()


func landed() -> void:
	timerFall.start()


func cleared() -> void:
	timerFall.stop()
	labelTime.text = str(timerFall.wait_time)


func _on_fall_timeout() -> void:
	currentState = state.fall


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	collision.set_deferred("disabled", true)
	visible = false
	timerReset.start()


func _on_reset_timeout() -> void:
	reset()
