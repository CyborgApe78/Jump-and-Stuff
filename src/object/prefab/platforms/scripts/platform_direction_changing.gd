extends AnimatableBody2D


## When enities lands on platform it moves in the direction of the arrow


signal spawned

enum state {idle, reset, move}
enum direction {Null, up, right, down, left}

@onready var startingPosition: Vector2 = global_position

@export var arrow: Node2D
@export var timerReset: Timer
@export var collision: CollisionShape2D
@export var areaCounter: Area2D

@export var startingDirection: direction:
	set(v):
		startingDirection = v
		turn_arrow(v)

@export_range(0.05, 10, 0.5) var timeReset: float = 1
@export var movingSpeed: int = 200 #TODO: function for blocks per sec

var currentState: int
var currentDirection: int


func _ready() -> void:
	turn_arrow(startingDirection)
	timerReset.wait_time = timeReset
	currentState = state.idle
	
	if startingDirection == direction.Null:
		EventBus.error.emit(str("moving direction null: " + str(name) + " at " + str(global_position)))


func _physics_process(delta: float) -> void:
	match currentState:
		state.idle:
			pass
		state.reset:
			pass
		state.move:
			if currentDirection == direction.up:
				position.y -= movingSpeed * delta
			elif currentDirection == direction.down:
				position.y += movingSpeed * delta
			elif currentDirection == direction.left:
				position.x -= movingSpeed * delta
			elif currentDirection == direction.right:
				position.x += movingSpeed * delta


func reset() -> void:
	currentState = state.idle
	global_position = startingPosition
	collision.set_deferred("disabled", false)
	visible = true
	spawned.emit()
	currentDirection = startingDirection
	turn_arrow(currentDirection)


func landed() -> void:
	if currentDirection != 0:
		if currentDirection == 4:
			currentDirection = 1
		else:
			currentDirection += 1
	else:
		currentDirection = startingDirection
	turn_arrow(currentDirection)
	
	if currentState == state.idle:
		currentState = state.move


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if currentState == state.move:
		collision.set_deferred("disabled", true)
		visible = false
		timerReset.start()
		currentState = state.reset


func _on_reset_timeout() -> void:
	reset()


func turn_arrow(point) -> void:
	if point == direction.up:
		arrow.rotation_degrees = 0
	elif  point == direction.down:
		arrow.rotation_degrees = 180
	elif  point == direction.left:
		arrow.rotation_degrees = 270
	elif  point == direction.right:
		arrow.rotation_degrees = 90


func _on_actor_counter_cleared() -> void:
	pass
