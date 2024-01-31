extends Marker2D
#TODO: fire without having target, change state if have one
#TODO: this needs to move with animations, add nodes in tree
#TODO: seperate aim and grapple target
#TODO: make it use bash detector area, but prefer one that is aimed if exist

@onready var player: CharacterBody2D = owner

@export_group("Connections")
@export var input: InputComponent
@export var color: Color = Color.FOREST_GREEN
@export var detector: ShapeCast2D
@export var indicatorAim: Line2D #TODO: make reusable
@export var indicatorTarget: Line2D #TODO: make reusable

@export_group("")

var aimInput: Vector2 
var target: TargetGrapple

var settings: Resource = preload("res://src/resources/SettingsConfig.tres")
#TODO: need to grapple lenght from player stats


func _ready() -> void:
	detector.set_collision_mask_value(CollisionLayers.GrappleHook, true)
	indicatorTarget.default_color = GameColor.grappleColor

func _physics_process(delta: float) -> void:
	aimInput = input.aimStrength if input.aimStrength != Vector2.ZERO else input.moveStrength
#	if settings.showAimIndicator: #TODO: set own var, not check resource all the time
	if aimInput != Vector2.ZERO:
		if input.aimDirection != Vector2.ZERO:
			indicatorAim.visible = true
		rotate_aim_indication()
		find_target()
	elif input.aimDirection == Vector2.ZERO and visible:
			indicatorAim.visible = false
			indicatorTarget.visible = false
			target = null


func rotate_aim_indication() -> void: ## rotates raycast and indicator
	var cast: Vector2 = aimInput * detector.target_position.length()
	var angle: = cast.angle()
	rotation = angle
	detector.force_shapecast_update()


func find_target() -> void:
	if detector.is_colliding():
		target = detector.get_collider(0)
		indicatorTarget.global_position = target.global_position
		indicatorTarget.visible = true 
		player.targetGrapple = target
	else: #FIXME: targetIndicator show on old target before disappearing
		target = null
		player.targetGrapple = target
		indicatorTarget.visible = false
