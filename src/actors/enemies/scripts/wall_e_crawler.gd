extends Enemies

## Crawls around walls

#var move = Vector2(0,0)
#var rotating: int
#
#func _physics_process(delta):
	#if rotating:
		#rotation = lerp_angle(rotation, move.angle(), 0.1)
		#rotating -= 1
		#return
	#
	#var col := move_and_collide(move * 200 * delta)
	#if col and col.get_normal().rotated(PI/2).dot(move) < 0.5:
		#rotating = 4
		#move = col.get_normal().rotated(PI/2)
		#return
	#
	#var pos := position
	#col = move_and_collide(move.rotated(PI/2) * 12)
	#if not col:
		#for i in 10:
			#position = pos
			#rotate(PI/32)
			#move = move.rotated(PI/32)
			#col = move_and_collide(move.rotated(PI/2) * 12)
			#
			#if col:
				#move = col.get_normal().rotated(PI/2)
				#rotation = move.angle()
				#break
	#else:
		#move = col.get_normal().rotated(PI/2)
		#rotation = move.angle()

#TODO: decide if bouncy or spikey



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
@export var allyDetector: RayCast2D
@export var ground: GroundDetectorComponent
@export var wallDetector: RayCast2D

@export_group("")
@export var startingState: state ## Intial State
@export var startDirection: = DIRECTION.LEFT

var moveDirection: int = 1
var startingPosition: Vector2
var currentState: int

enum DIRECTION {LEFT = -1, RIGHT = 1}
enum state {
	walk,
	fall,
	sleep,
}


func _ready() -> void:
	if is_on_floor():
		currentState = state.walk
	else:
		currentState = state.fall
	moveDirection = startDirection
	facing_logic(startDirection)

func _physics_process(delta: float) -> void:
	
	
	match currentState:
		state.walk:
			if not is_on_floor():
				currentState = state.fall
			#if wallDetector.is_colliding():
				#rotate(-moveDirection * 90)
				#facing_logic(-moveDirection)
			if not ground.detectorGroundMiddle.is_colliding():
				rotate(moveDirection * deg_to_rad(90))
			else:
				if ground.groundAngle != rotation:
					rotation = ground.groundAngle #FIXME: should this be rotation_degree
			velocity.x = moveDirection * moveSpeed
		state.fall:
			velocity.y += fallSpeed * delta
			if is_on_floor():
				currentState = state.walk
				velocity.y = 0
			if is_on_wall():
				velocity.x = 0
	
	
	move_and_slide()
