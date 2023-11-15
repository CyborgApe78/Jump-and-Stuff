extends MarginContainer


@export var stateLabel: Label
@export var velocityLabel: Label
@export var moveDirectionLabel: Label
@export var isGroundedLabel: Label
@export var groundAngleLabel: Label
@export var debugLabel: Label
@export var debug2Label: Label
@export var debug3Label: Label


func _ready():
	if OS.has_feature("editor"):
		visible = true
	EventBus.showDebug.connect(show_debug)
	EventBus.debugState.connect(set_state_label)
	EventBus.debugVelocity.connect(set_velocity_label)
	EventBus.debugMoveDirection.connect(set_move_direction_label)
	EventBus.debugIsGrounded.connect(set_is_grounded_label)
	EventBus.debugGroundAngle.connect(set_ground_angle_label)
	EventBus.debug.connect(set_debug_label)
	EventBus.debug2.connect(set_debug_2_label)
	EventBus.debug3.connect(set_debug_3_label)

func show_debug(BOOL) -> void:
	visible = BOOL

func set_state_label(info) -> void:
	stateLabel.text = "State: " + str(info)


func set_velocity_label(info) -> void:
	velocityLabel.text = "Velocity: " + str(info)
	
func set_move_direction_label(info) -> void:
	moveDirectionLabel.text = "Move Direction: " + str(info)

func set_is_grounded_label(info) -> void:
	isGroundedLabel.text = "Is Grounded: " + str(info)

func set_ground_angle_label(info) -> void:
	groundAngleLabel.text = "Ground Angle: " + str(info)


func set_debug_label(info) -> void:
	debugLabel.text = str(info)


func set_debug_2_label(info) -> void:
	debug2Label.text = str(info)


func set_debug_3_label(info) -> void:
	debug3Label.text = str(info)
