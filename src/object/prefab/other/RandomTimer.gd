extends Timer
class_name RandomTimer


@export var baseTime: float = 1.5
@export var timerRange: float = 0.5

@export var randomEveryTime: bool = true


func _ready() -> void:
	randomize()
	wait_time = get_new_timer()


func start(time_sec: float = -1) -> void:
	if randomEveryTime:
		wait_time = get_new_timer()
	super()


func get_new_timer() -> float:
	return randf_range(baseTime - timerRange, baseTime + timerRange)
