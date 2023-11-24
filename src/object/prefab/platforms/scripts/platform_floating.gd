extends AnimatableBody2D


## When enities lands on platform it falls, once clear return to original position
#TODO: add cardinal directions
#TODO: if groundpound go faster

signal spawned

@onready var startingPosition: Vector2 = global_position

@export_group("Connections")
@export var labelTime: Label
@export var timerReset: Timer
@export var collision: CollisionShape2D
@export var areaCounter: ActorCounterComponent

@export_group("")
@export_range(0.05, 10, 0.5) var timeReset: float = 1
@export var fallSpeed: int = 200
@export var oneUse: bool = false

enum state {idle, fall, rise}
var currentState: int


func _ready() -> void:
	timerReset.wait_time = timeReset
	currentState = state.idle


func _physics_process(delta: float) -> void:
	if currentState == state.rise and global_position == startingPosition:
		currentState = state.idle
	
	match currentState:
		state.idle:
			pass
		state.fall:
			position.y += fallSpeed * delta
		state.rise:
			position.y -= fallSpeed * delta



func reset() -> void:
	if oneUse:
		queue_free()
	else:
		currentState = state.idle
		global_position = startingPosition
		collision.set_deferred("disabled", false)
		visible = true
		spawned.emit()


func landed() -> void:
	currentState = state.fall


func cleared() -> void:
	currentState = state.rise


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if currentState == state.fall or state.rise:
		collision.set_deferred("disabled", true)
		visible = false
		timerReset.start()


func set_time_label(info: float) -> void:
	labelTime.text = str(info)



func _on_reset_timeout() -> void:
	reset()
