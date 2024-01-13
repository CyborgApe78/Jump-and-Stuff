extends Area2D

## Swing around a bar to launch away

#TODO: aim system like in PoP
#TODO: make player hands are anchor and not feet

@export var timeCooldown: float = 2
@export var timerCooldown: Timer
@export var remote: RemoteTransform2D
@export var control: Node

func _ready() -> void:
	timerCooldown.wait_time = timeCooldown
	
	if not control == null:
		remote.remote_path = control.get_path()


func _physics_process(delta: float) -> void:
	if not remote.remote_path == NodePath(""):
		remote.rotation += 10 * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.trapeze = self
		EventBus.playerInTrapeze.emit()
		remote.remote_path = body.get_path()


func _on_body_exited(body: Node2D) -> void:
	timerCooldown.start()
	remote.remote_path = NodePath("")
	set_deferred("monitoring", false)


func _on_timer_timeout() -> void:
	set_deferred("monitoring", true)
