extends Turrets

#FIXME: make cooldown when it can't be triggered, need to ignore trigger call 
#FIXME: crashes after the bullet is destroyed, but not on the regular turret

@export var detector: ActorDetector


func  _ready() -> void:
	super._ready()
	
	if not detector:
		EventBus.error.emit(name + " at " + str(global_position) + " has not trigger")
		return
	
	detector.triggerd.connect(prepare_to_shoot)


func prepare_to_shoot() -> void:
	super.prepare_to_shoot()
	#detector.set_deferred("monitoring", false) 


func reload_finished() -> void:
	super.reload_finished()
	#detector.set_deferred("monitoring", true) ##bad fix, makes autofire if staying in zone, see top fixme
