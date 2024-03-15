extends StaticHazard

#FIXME: they tigger each other
#TODO: use raycast to find wall and set the collision shape
#TODO: use polygon or maybe line2d for animation

@export_group("Connections")
@export var actorDetector: ActorDetector
@export var actorDetectorCollision: CollisionShape2D
@export var collision: CollisionShape2D
@export var body: CollisionShape2D
@export var timerWait: Timer
@export var timerHold: Timer
@export var timerRetract: Timer

@export_group("")
@export var timeWait: float = 0.3
@export var timeHold: float = 0.6
@export var timeExtend: float = 0.5
@export var timeRetract: float = 1

var startingBodySize: Vector2
var startingBodyPosition: Vector2


func _ready() -> void:
	timerWait.wait_time = timeWait
	timerHold.wait_time = timeHold
	timerRetract.wait_time = timeRetract
	
	startingBodySize = body.shape.size
	startingBodyPosition = body.position
	
	actorDetector.triggerd.connect(start_wait)


func start_wait() -> void:
	timerWait.start()
	actorDetector.set_deferred("monitoring", false)


func start_extend() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_method(update_collision, body.shape.size, Vector2(body.shape.size.x, actorDetectorCollision.shape.size.y), timeExtend)
	tween.tween_property(body, "position", Vector2(body.position.x, actorDetectorCollision.position.y), timeExtend).from_current()
	tween.tween_callback(start_hold).finished


func start_hold() -> void:
	timerHold.start()


func start_retract() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_method(update_collision, body.shape.size, Vector2(body.shape.size.x, startingBodySize.y), timeExtend)
	tween.tween_property(body, "position", Vector2(body.position.x, startingBodyPosition.y), timeExtend).from_current()
	tween.tween_callback(start_idle).finished


func start_idle() -> void:
	actorDetector.set_deferred("monitoring", true)


func update_collision(newPosition: Vector2) -> void:
	body.shape.size = newPosition


func _on_wait_timer_timeout() -> void:
	start_extend()


func _on_hold_timer_timeout() -> void:
	start_retract()


func _on_retract_timeout() -> void:
	start_idle()
