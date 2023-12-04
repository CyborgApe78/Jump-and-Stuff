extends Actor
class_name Player

#TODO: have the body collider react to rotation of rig

@onready var abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")

@onready var animPlayer: AnimationPlayer = $AnimationPlayer
@onready var sm: Node = $StateMachine
@onready var characterRig: Node2D = $CharacterRig
@onready var characterRotate: Node2D = $CharacterRig/CharacterRotate
@onready var characterCollision: CollisionShape2D = $BodyCollision
@onready var timers: Node = $Timers
@onready var sounds: Node = $Sounds
@onready var grappleHookLine: Line2D = $GrappleHook

@export_group("Connections")
@export var characterSAS: Node2D
@export var particles: Node2D
@export var input: InputComponent
@export var stats: StatsComponent


@export_group("")

var velocityPrevious: Vector2 = Vector2.ZERO
var velocityRotated: Vector2 = Vector2.ZERO
var GPMaxVelocity: Vector2 = Vector2.ZERO

var targetGrapple: TargetGrapple
var targetBash: TargetBash

var facing: int = 1

var jumped: bool

var currentStateName
var previousState

var groundColor: Color = Color.BLACK


func _ready() -> void:
	sm.init()
	default_ability_mask()
	EventBus.playerConsecutiveJump.connect(consecutive_jump_cancel)
	EventBus.teleportPlayer.connect(teleport_player)


func _unhandled_input(event: InputEvent) -> void:
	sm.handle_input(event)


func _physics_process(delta: float) -> void:
	sm.physics(delta)
	sm.state_check(delta)
	
	EventBus.debugVelocity.emit(velocity.round())
	EventBus.debugIsGrounded.emit(is_on_floor())


func _process(delta: float) -> void:
	sm.visual(delta)
	sm.sound(delta)
	
	squash_and_stretch(delta)


func move_and_slide_rotation() -> void:
	set_up_direction(-transform.y)
	velocity = velocity.rotated(rotation)
	move_and_slide()
	velocity = velocity.rotated(-rotation)


func squash_and_stretch(delta):
	var maxStretch: int
	
	if velocity.y < 0:
		maxStretch = max(velocity.y, stats.jumpVelocity)
	else:
		maxStretch = min(velocity.y, stats.jumpVelocity)
	
	if !is_on_floor():
		characterSAS.scale.y = remap(abs(maxStretch), 0, abs(stats.jumpVelocity), 0.75, 1.25)
		characterSAS.scale.x = remap(abs(maxStretch), 0, abs(stats.jumpVelocity), 1.25, 0.75)
	
	characterSAS.scale.x = lerp(characterSAS.scale.x, 1.0, 1.0 - pow(0.01, delta))
	characterSAS.scale.y = lerp(characterSAS.scale.y, 1.0, 1.0 - pow(0.01, delta))


func facing_logic(direction: int): #TODOL move this to another node
	if direction != 0 and characterRig.scale.x != direction:
		var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(characterRig, "scale", Vector2(direction, characterRig.scale.y), 0.4).from_current()
		facing = direction


func attempt_vertical_corner_correction(amount: int, delta) -> void:
	if test_move(global_transform, Vector2(velocity.x * delta, 0)): 
		for i in range(1, amount*2+1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(0, i * j / 2)), Vector2(velocity.x * delta, 0)):
					translate(Vector2(0, i * j / 2))
					if velocity.y * j < 0: velocity.y = 0
					EventBus.helperUsed.emit(Util.helper.cornerCorrectionVertical)
					return


func attempt_horizontal_corner_correction(amount: int, delta) -> void:
	if test_move(global_transform, Vector2(0, velocity.y * delta)):
		for i in range(1, amount*2+1):
			for j in [-1.0, 1.0]:
				if !test_move(global_transform.translated(Vector2(i * j / 2, 0)), Vector2(0, velocity.y * delta)):
					translate(Vector2(i * j / 2, 0))
					if velocity.x * j < 0: velocity.x = 0
					EventBus.helperUsed.emit(Util.helper.cornerCorrectionHorizontal)
					return


func consecutive_jump_cancel() -> void: 
	jumped = false
	timers.consecutiveJump.stop()
	abilities.reset(PlayerAbilities.listChain.JumpConsec)


func landed() -> void:
	animPlayer.play("Land") #TODO: create hard and soft land
	EventBus.playerLanded.emit()
	abilities.reset(PlayerAbilities.listUse.All)
	sounds.land.play()
	set_collision_mask_value(CollisionLayers.Semisolid, true)


func _on_dash_chain_timeout() -> void:
	pass
	#TODO: create particles


func ability_mask(layer: int, BOOL: bool) -> void:
	set_collision_mask_value(layer, BOOL)


func default_ability_mask() -> void:
	ability_mask(CollisionLayers.DashSide, true)
	ability_mask(CollisionLayers.DashUp, true)
	ability_mask(CollisionLayers.DashDown, true)
	ability_mask(CollisionLayers.GroundPound, true)


func teleport_player(location: Vector2) -> void:
	global_position = location
	velocity = Vector2.ZERO
	#TODO: healing on teleport


func animation_speed(scale: float) -> void:
	animPlayer.speed_scale = abs(velocity.x) * scale


func _on_bashable_detector_area_entered(area: TargetBash) -> void:
	targetBash = area


func _on_bashable_detector_area_exited(area: TargetBash) -> void:
	targetBash = null


func _on_semisoild_timeout() -> void:
	set_collision_mask_value(CollisionLayers.Semisolid, true)
