extends StaticHazard

## Spikes that extend from the wall

#TODO: add sound
#TODO: make time freeze state 

@export_group("Connections")
@export var hurtbox: HurtBox
@export var hurtCollider: CollisionShape2D
@export var timerWait: Timer
@export var timerHold: Timer
@export var spike: Line2D
@export var labelState: Label

@export_group("")
@export var timeWait: float = 0.5
@export var timeExtend: float = 0.5
@export var timeHold: float = 0.2
@export var timeRetract: float = 0.5

@export var _baseRange: int = 1:
	set(value):
		_baseRange = value
		extendRange = _baseRange * Util.tileSize
	get:
		return _baseRange

@onready var extendRange: int = _baseRange * Util.tileSize

var startinPosition: Vector2
var point1Start: int
var point2Start: int

var currentState:
	set(v):
		labelState.text = str(v)

enum state{
	idle,
	wait,
	extend,
	hold,
	retract,
}

func _ready() -> void:
	if OS.has_feature("editor"):
		labelState.visible = true
	
	spike.default_color = AbilityColor.hazardColor
	
	startinPosition = hurtbox.position
	point1Start = spike.points[1].y
	point2Start = spike.points[2].y
	
	timerHold.wait_time = timeHold
	timerWait.wait_time = timeWait
	
	currentState = state.wait
	start_wait()


func _physics_process(delta: float) -> void:
	match currentState:
		state.idle:
			pass
		state.wait:
			pass
		state.extend:
			pass
		state.hold:
			pass
		state.retract:
			pass


func start_idle() -> void:
	currentState = state.idle
	hurtbox.set_deferred("monitorable", false)


func start_wait() -> void:
	currentState = state.wait
	timerWait.start()
	hurtbox.set_deferred("monitorable", false)
	random_shake(spike, timeWait)


func start_extend() -> void:
	currentState = state.extend
	hurtbox.set_deferred("monitorable", true)
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(hurtbox, "position", Vector2(0, -extendRange/2), timeExtend).from_current()
	tween.tween_method(update_collision, hurtCollider.shape.size, Vector2(hurtCollider.shape.size.x, extendRange), (timeExtend * 1.2))
	tween.tween_method(update_point1, spike.points[1], spike.points[1] + Vector2(0, -extendRange), (timeExtend * 1.2))
	tween.tween_method(update_point2, spike.points[2], spike.points[2] + Vector2(0, -extendRange - 32), timeExtend)
	tween.tween_callback(start_hold).set_delay(timeExtend)


func start_hold() -> void:
	currentState = state.hold
	timerHold.start()


func start_retract() -> void:
	currentState = state.retract
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(hurtbox, "position", startinPosition, timeRetract).from_current()
	tween.tween_method(update_collision, hurtCollider.shape.size, Vector2(hurtCollider.shape.size.x, 1), (timeRetract * 0.8))
	tween.tween_method(update_point1, spike.points[1], Vector2(0, point1Start), (timeRetract * 0.8))
	tween.tween_method(update_point2, spike.points[2], Vector2(0, point2Start), timeRetract)
	tween.tween_callback(start_wait).set_delay(timeRetract)


func set_state_label(newState: int) -> void:
	labelState.text = str(newState)


func _on_wait_timer_timeout() -> void:
	start_extend()


func _on_hold_timer_timeout() -> void:
	start_retract()


func random_shake(node: Node, duration: float) -> void:
	var starPos: Vector2 = node.position
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "position", new_position(starPos), duration / 3).from_current()
	tween.tween_property(node, "position", new_position(starPos), duration / 3).from_current()
	tween.tween_property(node, "position", starPos, duration / 3).from_current()


func new_position(pos: Vector2) -> Vector2:
	var newX: int
	var newY: int
	
	newX = pos.x + randi_range(-2, 2)
	newY = pos.y + randi_range(-2, 2)
	
	return Vector2(newX, newY)


func update_point1(newPosition: Vector2) -> void:
	spike.set_point_position(1, newPosition)


func update_point2(newPosition: Vector2) -> void:
	spike.set_point_position(2, newPosition)


func update_collision(newPosition: Vector2) -> void:
	hurtCollider.shape.size = newPosition
