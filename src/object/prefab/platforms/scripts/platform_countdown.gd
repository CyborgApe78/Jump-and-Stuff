extends AnimatableBody2D


## When enities lands on platform counter goes down.
## If the counter reaches zero platform disappears
## If nothing is on the platform timer starts and adds back till counter reaches max

#TODO: get size and position of staticbody and set the area above
#TODO: create platform that reacts to number of bodies on
#LOOKAT: might need to change this to RigidBody for better detection

signal spawned

@export var labelCountdown: Label
@export var timerReset: Timer
@export var timerReplenish: Timer
@export var collision: CollisionShape2D

@export_range(1, 10) var maxLandings: int = 1
@export_range(0.05, 10, 0.5) var timeReset: float = 1
@export_range(0.05, 10, 0.5) var timeReplenish: float = 1

var remainingLandings: int = 0:
	set(v):
		remainingLandings = clamp(v, 0, maxLandings)
		labelCountdown.text = str(remainingLandings)
		if remainingLandings == 0:
			expired()




func _ready() -> void:
	timerReset.wait_time = timeReset
	timerReplenish.wait_time = timeReplenish
	reset()
	labelCountdown.text = str(remainingLandings)


func _physics_process(delta: float) -> void:
	pass


func reset() -> void:
	collision.set_deferred("disabled", false)
	remainingLandings = maxLandings
	spawned.emit()
	timerReplenish.stop()
	timerReset.stop()
	visible = true


func landed() -> void:
	remainingLandings -= 1
	timerReplenish.stop()


func cleared() -> void:
	timerReplenish.start()


func expired() -> void:
	collision.set_deferred("disabled", true)
	visible = false
	timerReset.start()


func _on_reset_timeout() -> void:
	reset()


func _on_replenish_timeout() -> void:
	remainingLandings += 1
	if remainingLandings != maxLandings:
		timerReplenish.start()
