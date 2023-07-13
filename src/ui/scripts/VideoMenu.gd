extends VBoxContainer


@export var buttonVsync: CheckButton
@export var buttonFullscreen: CheckButton
@export var buttonBorderless: CheckButton

var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	update_menu()


func update_menu() -> void:
	buttonVsync.button_pressed = settings.enableVsync
	buttonFullscreen.button_pressed = settings.enableFullscreen
#	buttonBorderless.button_pressed = settings.enableBorderless


func enable_vsync(toggled: bool) -> void:
	settings.enableVsync = toggled
	if toggled:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	


func enable_fullscreen(toggled: bool) -> void:
	settings.enableFullscreen = toggled
	if toggled:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func enable_borderless(toggled: bool) -> void:
	settings.enableBorderless = toggled
#	if toggled:
#		DisplayServer
#	else:
#		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
