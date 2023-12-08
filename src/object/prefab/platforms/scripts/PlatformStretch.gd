extends AnimatableBody2D

## Platform stretchs horizontal and vertical

#TODO: figure a way to change the size from code

@export_subgroup("Connections")
@export var collision: CollisionShape2D

@export_subgroup("")
@export var startVertical: bool = false
@export var speed: int = 200
@export var timeIdle: float = 1.0
@export var timeExtend: float = 1.0
@export var timeShrink: float = 1.0

var currentState: int
enum state{
	idle,
	stretchHorizontal,
	shrinkHorizontal,
	stretchVertical,
	shrinkVertical,
}


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
