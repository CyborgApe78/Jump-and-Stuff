extends StaticBody2D

## Spikes that extend from the wall when runover

#TODO: eventually look at using a line to tile spikes
#TODO: add sound
#TODO: varitations stayDeployed, timedDeploy
#TODO: make time freeze state 
#TODO: add new SpikeGroup

@export_group("Connections")
@export var hurtbox: HurtBox
@export var timerWait: Timer
@export var timerHold: Timer
@export var spikes: Node2D
@export var spike1: Line2D
@export var spike2: Line2D
@export var spike3: Line2D
@export var spike4: Line2D
@export var labelState: Label
@export var actorDetector: ActorDetector

@export_group("")
@export var timeWait: float = 0.5
@export var timeExtend: float = 0.5
@export var timeHold: float = 0.2
@export var timeRetract: float = 0.5

var startinPosition: Vector2

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
	
	for spike: Line2D in spikes.get_children():
		spike.default_color = GameColor.HAZARD
	
	actorDetector.triggerd.connect(start_wait)
	
	startinPosition = hurtbox.position
	timerHold.wait_time = timeHold
	timerWait.wait_time = timeWait
	currentState = state.idle


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
	actorDetector.set_deferred("monitoring", true)


func start_wait() -> void:
	currentState = state.wait
	actorDetector.set_deferred("monitoring", false)
	timerWait.start()
	
	for spike: Line2D in spikes.get_children():
		random_shake(spike, timeWait)


func start_extend() -> void:
	currentState = state.extend
	hurtbox.set_deferred("monitorable", true)
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(hurtbox, "position", Vector2(0, -64), timeExtend).from_current()
	tween.tween_method(update_point1, spike1.points[1], spike1.points[1] + Vector2(0, -32), (timeExtend * 1.2))
	tween.tween_method(update_point2, spike1.points[2], spike1.points[2] + Vector2(0, -64), timeExtend)
	tween.tween_callback(start_hold).set_delay(timeExtend)


func start_hold() -> void:
	currentState = state.hold
	timerHold.start()


func start_retract() -> void:
	currentState = state.retract
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(hurtbox, "position", startinPosition, timeRetract).from_current()
	tween.tween_method(update_point1, spike1.points[1], spike1.points[1] - Vector2(0, -32), (timeRetract * 0.8))
	tween.tween_method(update_point2, spike1.points[2], spike1.points[2] - Vector2(0, -64), timeRetract)
	tween.tween_callback(start_idle).set_delay(timeRetract)


func set_state_label(newState: int) -> void:
	labelState.text = str(newState)


func _on_wait_timer_timeout() -> void:
	start_extend()


func _on_hold_timer_timeout() -> void:
	start_retract()


func random_shake(node: Node, duration: float) -> void: #TODO: add this to global func
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


func update_point1(newPosition: Vector2):
	for spike: Line2D in spikes.get_children():
		spike.set_point_position(1, newPosition)


func update_point2(newPosition: Vector2):
	for spike: Line2D in spikes.get_children():
		spike.set_point_position(2, newPosition)
