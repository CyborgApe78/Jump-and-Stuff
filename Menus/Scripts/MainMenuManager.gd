extends CanvasLayer


@export var startingMenu: MainMenuBase
@export var mainMenu: MainMenuBase
@export var settings: MainMenuBase


func _ready() -> void:
	menu_hid()
	startingMenu.visible = true


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		if settings.visible:
			_on_main_menu_pressed()
	else:
		return


func menu_hid() -> void:
	mainMenu.visible = false 
	settings.visible = false



func _on_main_menu_pressed() -> void:
	menu_hid()
	startingMenu.visible = true


func _on_settings_pressed() -> void:
	menu_hid()
	settings.visible = true


