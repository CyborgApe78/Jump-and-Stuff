extends Control

#TODO: play and new game button, change name and show based on saved data

@export var labelTitle: Label
@export var labelVersion: Label
@export var labelGodot: Label
@export var labelCreator: Label

var GameInformation: Resource = preload("res://src/resources/GameInformation.tres")
var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func _ready() -> void:
	if !OS.has_feature("editor"):
		DisplayServer.window_set_size(DisplayServer.screen_get_size())
		if settings.enableFullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#TODO: add vsync
	labelTitle.text = GameInformation.gameName
	labelVersion.text = GameInformation.version
	labelGodot.text =  "Godot %s" % Engine.get_version_info().string
	labelCreator.text = GameInformation.creator
