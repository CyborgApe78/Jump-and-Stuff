extends Panel


@export var timerMove: Timer
@export var moveRange: int = 5
@export var baseTime: float = 1.5
@export var timerRange: float = 0.5
#@export var animTime: float = 0.5
#@export var animRange: float = 0.05


func _ready() -> void:
	timerMove.wait_time = get_new_timer()
	timerMove.start()


func _process(delta: float) -> void:
	pass


func move(newPosition: Vector2)-> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", newPosition, get_new_timer()).from_current()
	


func find_new_position() -> Vector2:
	var newX: int
	var newY: int
	
	newX = position.x + randi_range(-moveRange, moveRange)
	newY = position.y + randi_range(-moveRange, moveRange)
	
	return Vector2(newX, newY)


func get_new_timer() -> float:
	return randf_range(baseTime - timerRange, baseTime + timerRange)


func _on_timer_timeout() -> void:
	move(find_new_position())
	timerMove.wait_time = get_new_timer()
	timerMove.start()
