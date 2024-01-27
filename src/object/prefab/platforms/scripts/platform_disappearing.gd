extends AnimatablePlatform

## Disappears after the Player or Enemies land on it



@export_group("Connections")
@export var timerReset: Timer
@export var timerCountdown: Timer
@export var actorDetector: ActorDetector

@export_group("")
@export var timeReset: float = 1.0
@export var timeCountdown: float = 1.0


func _ready() -> void:
	super._ready()
	timerReset.wait_time = timeReset
	timerCountdown.wait_time = timeCountdown
	disappear(false)


## hids the platform and removes collision layer
func disappear(show: bool) -> void:
	visible = !show
	
	## Using Ground layer so that wall jump works correctly
	set_collision_layer_value(CollisionLayers.Ground, !show)


## when player or enemie land countdown starts and detector stops detecting
func _on_actor_detector_triggerd() -> void:
	actorDetector.set_deferred("monitoring", false)
	timerCountdown.start()


## disappears after timer ends
func _on_countdown_timeout() -> void:
	disappear(true)
	timerReset.start()


## visible after timer ends and turns detecting back on
func _on_reset_timeout() -> void:
	disappear(false)
	actorDetector.set_deferred("monitoring", true)
