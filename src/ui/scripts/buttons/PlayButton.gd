extends Button

func _ready() -> void:
	grab_focus()
	pressed.connect(_on_Play_pressed)

func _on_Play_pressed() -> void:
	get_tree().change_scene("res://Levels/Playground/Playground.tscn")
