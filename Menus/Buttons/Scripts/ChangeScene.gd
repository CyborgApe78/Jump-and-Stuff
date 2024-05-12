extends Button


@export var changeScene: PackedScene


func _on_pressed() -> void:
	if changeScene == null:
		print("No scene to change to")
		#TEMP: create error log
		return
	
	get_tree().change_scene_to_packed(changeScene)
