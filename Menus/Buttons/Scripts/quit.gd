extends Button


# Quits the game when pressed

func _on_pressed() -> void:
	#TEMP: add popup for confirmation, use ConfirmationDialog node
	get_tree().quit()
