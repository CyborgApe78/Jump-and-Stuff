extends AnimatableBody2D


## When enities lands on platform timer starts then platform falls when reaching zero

signal spawned

@onready var startingPosition: Vector2 = global_position

@export_group("Connections")
@export var labelTime: Label
@export var timerReset: Timer
@export var timerFall: Timer
@export var collision: CollisionShape2D
@export var areaCounter: Area2D
@export var neighborDetector: Area2D

@export_group("")
@export_range(0.05, 10, 0.5) var timeReset: float = 1
@export_range(0.05, 10, 0.5) var timeFall: float = 3
@export var fallSpeed: int = 200
@export var connectedMovement: bool = false

enum state {idle, shake, fall}
var currentState


func _ready() -> void:
	timerReset.wait_time = timeReset
	timerFall.wait_time = timeFall
	currentState = state.idle
	set_time_label(timerFall.wait_time)


func _physics_process(delta: float) -> void:
	if !timerFall.is_stopped():
		set_time_label(round(timerFall.time_left))
	match currentState:
		state.idle:
			pass
		state.shake:
			if connectedMovement:
				for i in neighborDetector.neighbors:
					i.set_time_label(round(timerFall.time_left)) 
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
	currentState = state.shake


func cleared() -> void:
	if currentState != state.fall:
		currentState = state.idle
		timerFall.stop()
		set_time_label(timerFall.wait_time)


func _on_fall_timeout() -> void:
	currentState = state.fall
	
	if connectedMovement:
		for i in neighborDetector.neighbors:
			i.currentState = state.fall


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	collision.set_deferred("disabled", true)
	visible = false
	timerReset.start()


func _on_reset_timeout() -> void:
	reset()


func set_time_label(info: float) -> void:
	labelTime.text = str(info)
