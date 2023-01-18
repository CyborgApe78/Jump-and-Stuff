extends RichTextLabel

@export var announcementDuration: float = 0.7
var timer: float
func _ready() -> void:
	timer = announcementDuration

func _process(delta: float) -> void:
	timer -= delta
	
	if timer < 0:
		queue_free()
