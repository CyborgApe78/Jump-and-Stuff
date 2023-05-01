extends MarginContainer


@export var errorText: TextEdit
@export var stateText: TextEdit
@export var actionText: TextEdit


func _ready() -> void:
	visible = false
	EventBus.showDebug.connect(show_debug)
	hide()
	EventBus.error.connect(enter_error_text)
	EventBus.playerStateChange.connect(enter_state_text)
	EventBus.playerActionAnnounce.connect(enter_action_text)
	#TODO: also send to log when that is added


func show_debug(BOOL) -> void:
	visible = BOOL


func enter_error_text(info) -> void:
	if OS.has_feature("editor"):
		show()
	errorText.text = str(errorText.text, "\n", info)
	errorText.set_v_scroll(9999999)


func enter_state_text(info) -> void:
	stateText.text = str(stateText.text, "\n", info)
	stateText.set_v_scroll(9999999)


func enter_action_text(info) -> void:
	actionText.text = str(actionText.text, "\n", info)
	actionText.set_v_scroll(9999999)
