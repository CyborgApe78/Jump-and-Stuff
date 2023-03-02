extends Interactable
#TODO: visability settings

var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_checkpoint_entered)
	EventBus.checkpointEntered.connect(check_active)
	modulate = Color.RED


func _on_checkpoint_entered(body) -> void:
	CheckpointSystem.set_checkpoint(global_position)
	EventBus.checkpointEntered.emit()

func check_active() -> void:
	if CheckpointSystem.currentRespawn == global_position:
		modulate = Color.GREEN
	else:
		modulate = Color.RED
