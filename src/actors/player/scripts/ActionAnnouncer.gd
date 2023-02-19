extends Node2D
#TODO: add setting to turn on
@onready var actionText: RichTextLabel = $ActionText

func _ready() -> void:
	EventBus.actionAnnounce.connect(announce_action)


func announce_action(action: String) -> void:
	var floatingText: RichTextLabel = actionText.duplicate()
	floatingText.set_process_mode(PROCESS_MODE_INHERIT)
	floatingText.text = "[center][rainbow][wave]" + action
	floatingText.position = global_position
	
	get_tree().get_root().add_child(floatingText)
