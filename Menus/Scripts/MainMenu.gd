extends MainMenuBase


#func _input(_event: InputEvent) -> void:
	### Exit game when back/cancel is pressed
	#if Input.is_action_just_pressed("ui_cancel"):
		##TEMP: add popup for confirmation, use ConfirmationDialog node
		#get_tree().quit()

#TODO: make back button connect to the menu manager
