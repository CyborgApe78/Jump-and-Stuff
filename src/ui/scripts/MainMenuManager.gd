extends CanvasLayer


@export var startingMenu: MainMenuBase
@export var mainMenu: MainMenuBase
@export var worldSelect: MainMenuBase
@export var settings: MainMenuBase
@export var cursor: Cursor


func _ready() -> void:
	menu_hid()
	startingMenu.visible = true
	startingMenu.on_visible_focus()


func menu_hid() -> void:
	mainMenu.visible = false
	worldSelect.visible = false
	settings.visible = false
	cursor.visible = false


func _on_world_select_pressed() -> void:
	menu_hid()
	worldSelect.visible = true
	worldSelect.on_visible_focus()


func _on_main_menu_pressed() -> void:
	menu_hid()
	startingMenu.visible = true
	startingMenu.on_visible_focus()


func _on_settings_pressed() -> void:
	menu_hid()
	settings.visible = true
	settings.on_visible_focus()
