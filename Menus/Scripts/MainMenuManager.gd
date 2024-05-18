extends CanvasLayer


@export var startingMenu: MainMenuBase
@export var mainMenu: MainMenuBase
@export var settings: MainMenuBase

enum State {
	Main,
	Settings
}

var currentMenu: int
var previousMenu: int


func _ready() -> void:
	menu_hid()
	startingMenu.visible = true
	startingMenu.enter()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		## Return to main menu
		if currentMenu != State.Main:
			_on_main_menu_pressed()
		elif currentMenu == State.Main:
		### Exit game when back/cancel is pressed
		##TEMP: add popup for confirmation, use ConfirmationDialog node
			get_tree().quit()
	else:
		return


## Hides all menus
func menu_hid() -> void:
	mainMenu.visible = false 
	settings.visible = false

## Show main menu
func _on_main_menu_pressed() -> void:
	menu_hid()
	mainMenu.visible = true
	change_menu(State.Main)
	startingMenu.enter()


## Show settings menu
func _on_settings_pressed() -> void:
	menu_hid()
	settings.visible = true
	settings.enter()
	change_menu(State.Settings)


## What to do when back button is pressed
func _on_back_pressed() -> void:
	if previousMenu == State.Main:
		_on_main_menu_pressed()
	elif previousMenu == State.Settings:
		_on_settings_pressed()
	else:
		print("Unknown Menu")


## keeps track of what menu is active
func change_menu(menu: int) -> void:
	previousMenu = currentMenu
	currentMenu = menu
