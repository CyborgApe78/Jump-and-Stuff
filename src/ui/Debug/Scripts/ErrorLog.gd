extends MarginContainer

#TODO: setting to show
@onready var errorText: TextEdit = $MarginContainer/TextEdit


func _ready() -> void:
	visible = false
	EventBus.showDebug.connect(show_debug)
	hide()
	EventBus.error.connect(enter_text)
	#TODO: also send to log when that is added


func show_debug(BOOL) -> void:
	visible = BOOL


func enter_text(info) -> void:
	show()
	errorText.text = str(errorText.text, "\n", info)
	errorText.set_v_scroll(9999999)
