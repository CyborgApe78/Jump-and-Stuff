extends Label


## Gets Godot version and changes label text

func _ready() -> void:
	text = "Godot %s" % Engine.get_version_info().string
