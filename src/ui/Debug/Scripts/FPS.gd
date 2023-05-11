extends MarginContainer


@export var fpsLabel: Label



func _ready():
	if OS.has_feature("editor"):
		visible = true

func _physics_process(delta: float) -> void:
	fpsLabel.text = "FPS: " + str(Engine.get_frames_per_second())
