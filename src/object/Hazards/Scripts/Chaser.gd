extends Path2D

## Hazard following path but reacts to player

@export_group("Connections")
@export var follow: PathFollow2D
@export var remote: RemoteTransform2D

@export_group("")
@export var speed: int = 50

var defaultSpeed: int

var currentState: int
enum state{
	idle,
	chase,
}


func _ready() -> void:
	defaultSpeed = speed


func _physics_process(delta: float) -> void:
	follow.progress += speed * delta


func _on_player_detector_body_entered(body: Node2D) -> void:
	speed *= 0.25


func _on_player_detector_body_exited(body: Node2D) -> void:
	speed = defaultSpeed
