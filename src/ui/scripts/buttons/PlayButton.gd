extends Button


@export var changeScene: PackedScene


func _ready() -> void:
	grab_focus()


func _on_pressed() -> void:
	get_tree().change_scene_to_packed(changeScene)
