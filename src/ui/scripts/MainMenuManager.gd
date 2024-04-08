extends CanvasLayer


@export var startingMenu: MainMenuBase
@export var mainMenu: MainMenuBase
@export var worldSelect: MainMenuBase
@export var testSelect: MainMenuBase
@export var settings: MainMenuBase
@export var cursor: Cursor


func _ready() -> void:
	menu_hid()
	startingMenu.visible = true
	startingMenu.on_visible_focus()


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_back"):
		if worldSelect.visible or settings.visible:
			_on_main_menu_pressed()


func menu_hid() -> void:
	mainMenu.visible = false 
	worldSelect.visible = false
	settings.visible = false
	cursor.visible = false
	testSelect.visible = false


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


func _on_test_chambers_pressed() -> void:
	menu_hid()
	testSelect.visible = true
	testSelect.on_visible_focus()
