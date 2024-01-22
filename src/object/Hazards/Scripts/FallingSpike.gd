extends AnimatableBody2D

## Spikes that fall down and make a platform

#TODO: add sound
#TODO: make non platform version
#TODO: add in length export
#TODO: have detector stretch to ground


@export_group("Connections")
@export var detector: Area2D
@export var hurtbox: HurtBox
@export var hurtCollider: CollisionShape2D
@export var timerWait: Timer
@export var spike: Line2D
@export var labelState: Label
@export var groundDetector: RayCast2D

@export_group("")
@export var movingSpeed: int = 200 #TODO: function for blocks per sec
@export var timeWait: float = 0.5

var startinPosition: Vector2

var currentState: int
var previousState: int

enum state{
	idle,
	wait,
	fall,
	ground,
	freeze,
}

func _ready() -> void:
	if OS.has_feature("editor"):
		labelState.visible = true
	
	spike.default_color = AbilityColor.hazardColor
	timerWait.wait_time = timeWait
	currentState = state.idle
	EventBus.timeFreeze.connect(freeze_time)


func _physics_process(delta: float) -> void:
	match currentState:
		state.idle:
			pass
		state.wait:
			pass
		state.fall:
			position.y += movingSpeed * delta
			if groundDetector.is_colliding():
				currentState = state.ground
		state.ground:
			pass
		state.freeze:
			pass


func start_idle() -> void:
	currentState = state.idle
	labelState.text = str(currentState)
	detector.set_deferred("monitoring", true)
	hurtbox.set_deferred("monitorable", false)


func start_wait() -> void:
	currentState = state.wait
	labelState.text = str(currentState)
	detector.set_deferred("monitoring", false)
	timerWait.start()
	random_shake(spike, timeWait)


func start_fall() -> void:
	currentState = state.fall
	labelState.text = str(currentState)
	hurtbox.set_deferred("monitorable", true)



func set_state_label(newState: int) -> void:
	labelState.text = str(newState)


func _on_wait_timer_timeout() -> void:
	start_fall()


func freeze_time(v: bool) -> void:
	if v:
		if not timerWait.is_stopped():
			timerWait.paused = true
		previousState = currentState
		currentState = state.freeze
	else:
		if previousState == state.wait:
			timerWait.paused = false
		currentState = previousState


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


func _on_actor_detector_body_entered(body: Actor) -> void:
	start_wait()


func update_point1(newPosition: Vector2) -> void:
	spike.set_point_position(1, newPosition)


func update_point2(newPosition: Vector2) -> void:
	spike.set_point_position(2, newPosition)
