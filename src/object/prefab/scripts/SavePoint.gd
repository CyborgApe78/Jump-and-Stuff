extends Interactable
class_name SavePoint

var cpSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")
var wpSystem: Resource = preload("res://src/resources/WaypointSysten.tres")


func _ready() -> void:
	super._ready()
	body_entered.connect(on_save_pointed_entered)
	EventBus.checkpointEntered.connect(check_active)
	modulate = Color.RED


func on_save_pointed_entered(body) -> void:
	#FIXME: breeks if checkpoint is at 0,0
	#TODO: button press to activate, lets death warp
	if cpSystem.currentRespawn != global_position: ## won't trigger if current respawm
		cpSystem.set_checkpoint(global_position)
		EventBus.checkpointEntered.emit()


func check_active() -> void:
	if cpSystem.currentRespawn == global_position:
		modulate = Color.GREEN
	else:
		modulate = Color.RED
