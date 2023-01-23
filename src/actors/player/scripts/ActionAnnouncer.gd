extends Node2D

@onready var actionText: RichTextLabel = $ActionText

func _ready() -> void:
	EventBus.connect("actionAnnounce", announce_action)


func announce_action(action: String) -> void:
	var floatingText: RichTextLabel = actionText.duplicate()
	floatingText.process_mode = true
	floatingText.text = "[center][rainbow][wave]" + action
	floatingText.position = global_position
	
	get_tree().get_root().add_child(floatingText)
