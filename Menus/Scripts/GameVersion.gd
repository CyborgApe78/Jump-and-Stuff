extends Label


## Gets game version and changes label text

func _ready() -> void:
	text = GameInfo.VERSION
