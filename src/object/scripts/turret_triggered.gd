extends Turrets

#TODO: make cooldown when it can't be triggered

@export var detector: ActorDetector


func  _ready() -> void:
	super._ready()
	
	if not detector:
		EventBus.error.emit(name + " at " + str(global_position) + " has not trigger")
		return
	
	detector.triggerd.connect(prepare_to_shoot)

