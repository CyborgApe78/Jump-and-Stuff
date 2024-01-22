extends Enemies
class_name SpikEsides

## Slow moving enemy that can be bounced on. Sides hurt player

#TODO: moves stats to base enemy class
#TODO: Eye blink, look at player

enum DIRECTION {LEFT = -1, RIGHT = 1}

@export_group("Stats")
@export_subgroup("Speed")
@export var _baseMove: float = 4:
	set(value):
		_baseMove = value
		moveSpeed = _baseMove * Util.tileSize
	get:
		return _baseMove
## This value makes the time it takes to reach maximum speed smoother.
@export_range(0.0 , 2.0, 0.01) var _baseAcceleration: float = 1.2
## The force applied to slow down the character's movement.
@export_range(0.0 , 1.0, 0.01) var _baseFriction: float = 0.5
## Modulates the rate of horizontal speed decrease during airborne movement.
@export_range(0.0 , 2.0, 0.01) var baseAirMovement: float = 1.0 #LOOKAT: remove

@onready var moveSpeed: int = _baseMove * Util.tileSize
@onready var accelerationGround: float = moveSpeed / _baseAcceleration
@onready var frictionGround: float = moveSpeed / _baseFriction
@onready var accelerationAir: float = moveSpeed / (_baseAcceleration * baseAirMovement)
@onready var frictionAir: float = moveSpeed / (_baseFriction * baseAirMovement)

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
@export var hurtbox: HurtBox
@export var bouncebox: Area2D #TODO: create class_name
@export var allyDetector: RayCast2D
@export var ground: GroundDetectorComponent
@export var detector: Node2D

@export_group("")
@export var startingState: state
@export var startDirection: = DIRECTION.LEFT
@export var ignoreLedges: bool = false
@export var respawn: bool = false


var moveDirection: int = 1
var startingPosition: Vector2
var previousVelocity: Vector2

var currentState: int
var previousState: int

enum state {
	walk,
	fall,
	sleep,
	freeze,
}


func _ready() -> void:
	startingPosition = global_position
	EventBus.timeFreeze.connect(freeze)
	if is_on_floor():
		currentState = startingState
	else:
		currentState = state.fall
		
	moveDirection = startDirection
	detector.scale.x = startDirection
	facing_logic(startDirection)


func _physics_process(delta: float) -> void:
	if ground.groundAngle != rotation:
		rotation = ground.groundAngle
	
	match currentState:
		state.walk:
			if not ignoreLedges:
				if ground.ledgeLeft:
					moveDirection *= -1
					facing_logic(moveDirection)
					detector.scale.x = moveDirection
				if ground.ledgeRight:
					moveDirection *= -1
					facing_logic(moveDirection)
					detector.scale.x = moveDirection
			if not is_on_floor():
				currentState = state.fall
			velocity.x = moveDirection * moveSpeed
		state.fall:
			velocity.y += fallSpeed * delta
			if is_on_floor():
				currentState = state.walk
				velocity.y = 0
			if is_on_wall():
				velocity.x = 0
		state.freeze:
			velocity = Vector2.ZERO
	
	move_and_slide()
	
	if is_on_wall() or allyDetector.is_colliding():
		moveDirection *= -1
		facing_logic(moveDirection)
		detector.scale.x = moveDirection
	
	labelVelocity.text = str(velocity.round())






func die() -> void:
	if respawn:
		spawn()
	else:
		queue_free()


func spawn() -> void:
	rig.scale.y = 1
	global_position = startingPosition
	hurtbox.set_deferred("monitoring", true)


func freeze(v: bool) -> void:
	if v:
		previousVelocity = velocity
		previousState = currentState
		currentState = state.freeze
	else:
		velocity = previousVelocity
		currentState = previousState


func _on_bounce_box_body_entered(body: Actor) -> void:
	if body is Player:
		#if body.velocity.y > 0: #TODO: find way to detect player is above. global position doesn't work as desired
		hurtbox.set_deferred("monitoring", false)
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(rig, "scale", Vector2(rig.scale.x, 0), 0.2).from_current()
		tween.tween_callback(die).finished

