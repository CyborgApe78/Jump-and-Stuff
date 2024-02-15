extends StaticHazard

#TODO: timefreeze
#FIXME: find a better way to handle hurtbox, probably animationplayer
#TODO: Add movement look (freeze) to hurt box. Will need to turn off collider on the chomper mouth

@export_category("Connections")
@export var detector: ActorDetector
@export var leftSide: AnimatableBody2D
@export var rightSide: AnimatableBody2D
@export var timerHold: Timer
@export var timerWait: Timer
@export var timerHurtbox: Timer
@export var spikesLeft: SpikeGroup
@export var spikesRight: SpikeGroup
@export var hurtbox: HurtBox

@export_category("")
@export var timeHold: float = 0.9
@export var timeWait: float = 0.8
@export var timeClose: float = 0.5
@export var timeOpen: float = 1.5


func _ready() -> void:
	timerHold.wait_time = timeHold
	timerWait.wait_time = timeWait
	timerHurtbox.wait_time = timeClose * 0.35


func wait()-> void:
	detector.set_deferred("monitoring", false)
	timerWait.start()
	spikesLeft.shake(timeWait)
	spikesRight.shake(timeWait)


func close_arms() -> void:
	timerHurtbox.start()
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(leftSide, "rotation_degrees", 90, timeClose).from(0)
	tween.tween_property(rightSide, "rotation_degrees", -90, timeClose).from(0)
	tween.tween_callback(hold).finished
	
	spikesLeft.extend(timeOpen)
	spikesRight.extend(timeOpen)


func hold() -> void:
	timerHold.start()


func open_arms() -> void:
	hurtbox.set_deferred("monitoring", false)
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT).set_parallel(true)
	tween.tween_property(leftSide, "rotation_degrees", 0, timeOpen).from_current()
	tween.tween_property(rightSide, "rotation_degrees", 0, timeOpen).from_current()
	tween.tween_callback(idle).finished
	
	spikesLeft.retract(timeOpen)
	spikesRight.retract(timeOpen)


func idle() -> void:
	detector.set_deferred("monitoring", true)

func activate_hurtbox() -> void:
	hurtbox.set_deferred("monitoring", true)
