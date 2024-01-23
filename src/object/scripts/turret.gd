extends Turrets

@export_group("Connections")
@export var timerAutofire: Timer

@export_category("")
@export var timeAutofire: float = 1.0


func _ready() -> void:
	super._ready()
	reloaded.connect(auto_fire)
	timerAutofire.wait_time = timeAutofire
	


func auto_fire() -> void:
	timerAutofire.start()


func _on_autofire_timeout() -> void:
	prepare_to_shoot()
