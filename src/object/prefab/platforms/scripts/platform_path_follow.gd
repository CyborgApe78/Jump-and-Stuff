extends Path2D


## Platform that follows a path


@export_subgroup("Connections")
@export var platform: NodePath
@export var defaultPlatform: AnimatableBody2D
@export var follow: PathFollow2D
@export var line: Line2D
@export var remote: RemoteTransform2D

@export_subgroup("")
@export var speed: int

var currentState: int
enum state{
	idle,
	back,
	forth,
}

func _ready() -> void:
	#if platform != null: #FIXME: platform doesn't move
		#remote.remote_path = platform
		#defaultPlatform.queue_free()
	
	if curve != null:
		line.points = curve.get_baked_points()
	else:
		EventBus.error.emit(str("Platform Path Follow null: " + str(name) + " at " + str(global_position)))
	
	currentState = state.back #TODO: add setting for player needing to land on it


func _physics_process(delta: float) -> void:
	if follow.progress_ratio == 0:
		currentState = state.back
	elif follow.progress_ratio == 1:
		currentState = state.forth
	
	match currentState:
		state.back:
			follow.progress += speed * delta
		state.forth:
			follow.progress -= speed * delta
