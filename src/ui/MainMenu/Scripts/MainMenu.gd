extends MainMenuBase


@export var labelTitle: Label
@export var labelVersion: Label
@export var labelGodot: Label
@export var labelCreator: Label

var gInfo: Resource = preload("res://src/resources/GameInformation.tres")
var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	if !OS.has_feature("editor"):
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		if settings.enableFullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	labelTitle.text = gInfo.gameName
	labelVersion.text = gInfo.version
	labelGodot.text = "Godot %s" % Engine.get_version_info().string
	labelCreator.text = gInfo.creator
