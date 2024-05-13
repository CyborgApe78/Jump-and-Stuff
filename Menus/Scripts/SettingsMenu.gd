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

var settings: Resource = preload("res://src/resources/SettingsConfig.tres")


func enter() -> void:
	self.visible = true
	menu_hid()
	#TEMP: need to make a dictionary to connect the buttons to the menu
	controlsMenu.visible = true
	buttonFirst.grab_focus()


func exit() -> void:
	ResourceSaver.save(settings)
	EventBus.settingsUpdate.emit()
	self.visible = false


#func state_check() -> int:
	#return State.Null


func back_button_pressed() -> void:
	pass


func menu_hid() -> void:
	for child in optionsContainer.get_children():
		child.visible = false 


func show_gameplay() -> void:
	menu_hid()
	gameplayMenu.visible = true


func show_accessibility() -> void:
	menu_hid()
	accessibilityMenu.visible = true


func show_hud() -> void:
	menu_hid()
	#hudMenu.update_menu()
	hudMenu.visible = true


func show_video() -> void:
	menu_hid()
	videoMenu.visible = true


func show_audio() -> void:
	menu_hid()
	audioMenu.visible = true


func show_controls() -> void:
	menu_hid()
	controlsMenu.visible = true


func show_colors() -> void:
	menu_hid()
	colorsMenu.visible = true

