extends Interactable
class_name SavePoint

var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")
var WaypointSystem: Resource = preload("res://src/resources/WaypointSysten.tres")


func _ready() -> void:
	super._ready()
	body_entered.connect(on_save_pointed_entered)
	EventBus.checkpointEntered.connect(check_active)
	modulate = Color.RED


func on_save_pointed_entered(body) -> void:
	#FIXME: breeks if checkpoint is at 0,0
	#TODO: button press to activate, lets death warp
	if CheckpointSystem.currentRespawn != global_position: ## won't trigger if current respawm
		CheckpointSystem.set_checkpoint(global_position)
		EventBus.checkpointEntered.emit()


func check_active() -> void:
	if CheckpointSystem.currentRespawn == global_position:
		modulate = Color.GREEN
	else:
		modulate = Color.RED
