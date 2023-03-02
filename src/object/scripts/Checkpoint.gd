extends Interactable


var CheckpointSystem: Resource = preload("res://src/resources/CheckpointSystem.tres")


func _ready() -> void:
	super._ready()
	body_entered.connect(_on_checkpoint_entered)


func _on_checkpoint_entered(body) -> void:
	CheckpointSystem.set_checkpoint(global_position)

