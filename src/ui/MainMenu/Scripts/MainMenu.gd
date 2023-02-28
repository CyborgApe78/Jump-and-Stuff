extends Control

@export var labelTitle: Label
@export var labelVersion: Label
@export var labelGodot: Label
@export var labelCreator: Label


var GameInformation: Resource = preload("res://src/resources/GameInformation.tres")


func _ready() -> void:
	labelTitle.text = GameInformation.gameName
	labelVersion.text = GameInformation.version
	labelGodot.text =  "Godot %s" % Engine.get_version_info().string
	labelCreator.text = GameInformation.creator
