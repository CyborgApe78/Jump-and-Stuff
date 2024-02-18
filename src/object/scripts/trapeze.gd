extends Area2D

## Swing around a bar to launch away

#TODO: add buid up for speed
#TODO: make player hands are anchor and not feet
#TODO: grab player facing direction to determine spin directions

@export var timeCooldown: float = 2
@export var timerCooldown: Timer
@export var remote: RemoteTransform2D
@export var control: Node
@export var aimIndicatitor: Line2D

var aimDirection: Vector2 = Vector2.UP


func _ready() -> void:
	aimIndicatitor.visible = false
	timerCooldown.wait_time = timeCooldown
	
	if not control == null:
		remote.remote_path = control.get_path()


func _physics_process(delta: float) -> void:
	if not remote.remote_path == NodePath(""):
		aimDirection = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		aimIndicatitor.look_at(aimIndicatitor.global_position + aimDirection)
		remote.rotation += 10 * delta
		


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		aimIndicatitor.visible = true
		body.trapeze = self
		EventBus.playerInTrapeze.emit()
		remote.remote_path = body.get_path()


func _on_body_exited(body: Node2D) -> void:
	aimIndicatitor.visible = false
	timerCooldown.start()
	remote.remote_path = NodePath("")
	set_deferred("monitoring", false)
	aimDirection = Vector2.UP


func _on_timer_timeout() -> void:
	set_deferred("monitoring", true)
