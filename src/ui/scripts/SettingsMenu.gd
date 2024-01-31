extends BaseMenu

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
	set_paused(true)
	self.visible = true
	menu_hid()
	gameplayMenu.visible = true
	gameplayButton.grab_focus()


func exit() -> void:
	ResourceSaver.save(settings)
	EventBus.settingsUpdate.emit()
	self.visible = false


func handle_input(event: InputEvent) -> int:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back"):
		return State.Paused
	
	return State.Null


func state_check() -> int:
	return State.Null


func back_button_pressed() -> void:
	EventBus.menuChanged.emit(State.Paused)


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
	hudMenu.update_menu()
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


func show_colorss() -> void:
	menu_hid()
	colorsMenu.visible = true
