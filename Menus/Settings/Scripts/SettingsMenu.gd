extends MainMenuBase

#TODO: when submenu is open, need to focus first button

enum State{
	Null,
	Gameplay,
	HUD,
	Accessibility,
	Video,
	Audio,
	Controls,
	Colors,
	}

var states = {
	State.Gameplay: gameplayMenu,
	State.HUD: hudMenu,
	State.Accessibility: accessibilityMenu,
	State.Video: videoMenu,
	State.Audio: audioMenu,
	State.Controls: controlsMenu,
	State.Colors: colorsMenu,
	}

var baseLevel: int = 80

@export var optionsContainer: Control
@export var gameplayMenu: VBoxContainer
@export var hudMenu: VBoxContainer
@export var accessibilityMenu: VBoxContainer
@export var videoMenu: VBoxContainer
@export var audioMenu: VBoxContainer
@export var controlsMenu: VBoxContainer
@export var colorsMenu: VBoxContainer
@export var backButton: Button
@export var gameplayButton: Button
@export var hudButton: Button
@export var accessibilityButton: Button
@export var videoButton: Button
@export var audioButton: Button
@export var controlsButton: Button 
@export var colorsButton: Button

var userPref: ConfigFile 


func enter() -> void:
	visible = true
	menu_hid()
	#TEMP: need to make a dictionary to connect the buttons to the menu
	controlsMenu.visible = true
	buttonFirst.grab_focus()


func exit() -> void:
	#userPref.save() #TODO: save and load
	EventBus.settingsUpdate.emit()
	visible = false


#func state_check() -> int:
	#return State.Null


func back_button_pressed() -> void:
	pass


func menu_hid() -> void:
	for child in optionsContainer.get_children():
		child.visible = false 


func show_gameplay() -> void:
	menu_hid()
	gameplayMenu.enter()


func show_accessibility() -> void:
	menu_hid()
	accessibilityMenu.enter()


func show_hud() -> void:
	menu_hid()
	#hudMenu.update_menu()
	hudMenu.enter()


func show_video() -> void:
	menu_hid()
	videoMenu.enter()


func show_audio() -> void:
	menu_hid()
	audioMenu.enter()


func show_controls() -> void:
	menu_hid()
	controlsMenu.enter()


func show_colors() -> void:
	menu_hid()
	colorsMenu.enter()

