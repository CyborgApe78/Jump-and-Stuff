extends Enemies
class_name SpikEJumper

## Jumps when the player jumps

#TODO: animation
#TODO: make only trigger from grounded jumps

@export_group("Stats")
@export_subgroup("Jump")
@export var _baseJump: float = 10:
	set(value):
		_baseJump = value
		jumpSpeed = _baseJump * Util.tileSize
	get:
		return _baseJump

@onready var jumpSpeed: int = _baseJump * Util.tileSize #TODO: get equation from player

@export_subgroup("Fall")
@export var _baseFall: float = 30:
	set(value):
		_baseFall = value
		fallSpeed = _baseFall * Util.tileSize
	get:
		return _baseFall

@onready var fallSpeed: int = _baseFall * Util.tileSize


@export_group("Connections")
@export var labelVelocity: Label
@export var timerWait: Timer
@export var hurtbox: HurtBox

@export_group("")
@export var timeWait: float = 0.5

var startingPosition: Vector2
var previousVelocity: Vector2

var currentState: int
var previousState: int
enum state {
	idle,
	wait,
	jump,
	fall,
	freeze
}


func _ready() -> void:
	startingPosition = global_position
	timerWait.wait_time = timeWait
	EventBus.playerJumped.connect(prepare_jump)
	EventBus.timeFreeze.connect(freeze)
	
	if not is_on_floor():
		currentState = state.fall


func _physics_process(delta: float) -> void:
	$State.text = str(currentState)
	
	if not is_on_floor():
		currentState = state.fall
		
	match currentState:
		state.idle:
			pass
		state.wait:
			pass
		state.jump:
			velocity.y += fallSpeed * delta
			if velocity.y > 0:
				currentState = state.fall
		state.fall:
			velocity.y += fallSpeed * delta
			if is_on_floor():
				currentState = state.idle
				velocity.y = 0
		state.freeze:
			velocity = Vector2.ZERO
	
	move_and_slide()
	
	labelVelocity.text = str(velocity.round())


func prepare_jump() -> void:
	if currentState == state.idle:
		to_wait()


func to_wait() -> void:
	currentState = state.wait
	timerWait.start()


func to_jump() -> void:
	currentState = state.jump
	velocity.y = -jumpSpeed


func freeze(v: bool) -> void:
	if v:
		previousVelocity = velocity
		previousState = currentState
		currentState = state.freeze
		timerWait.paused = true
	else:
		velocity = previousVelocity
		currentState = previousState
		timerWait.paused = false


func facing_logic(direction: int):
	if direction != 0 and rig.scale.x != direction:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(rig, "scale", Vector2(direction, rig.scale.y), 0.4).from_current()


func _on_wait_timer_timeout() -> void:
	to_jump()
