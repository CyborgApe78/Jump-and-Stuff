extends BaseMenu

onready var settingsContainer: MarginContainer = $M/H/Options/M
onready var gameplayMenu: VBoxContainer = $"%GameplayMenu"
onready var accessibilityMenu: VBoxContainer = $"%AccessibilityMenu"
onready var videoMenu: VBoxContainer = $"%VideoMenu"
onready var audioMenu: VBoxContainer = $"%AudioMenu"
onready var keybindingMenu: VBoxContainer = $"%KeybindgsMenu"
onready var backButton: Button = $"%Back"
onready var gameplayButton: Button = $"%Gameplay"
onready var accessibilityButton: Button = $"%Accessibility"
onready var videoButton: Button = $"%Video"
onready var audioButton: Button = $"%Audio"
onready var keybindingsButton: Button = $"%Keybindings"


func _ready() -> void:
	backButton.connect("pressed", self, "back_button_pressed")
	gameplayButton.connect("pressed", self, "show_gameplay")
	accessibilityButton.connect("pressed", self, "show_accessibility")
	videoButton.connect("pressed", self, "show_video")
	audioButton.connect("pressed", self, "show_audio")
	keybindingsButton.connect("pressed", self, "show_keybindings")

func enter() -> void:
	set_paused(true)
	self.visible = true
	menu_hid()
	gameplayMenu.visible = true
	gameplayButton.grab_focus()

func exit() -> void:
	EventBus.emit_signal("settingsUpdate")
	self.visible = false

func handle_input(event: InputEvent) -> BaseMenu:
	if Input.is_action_just_pressed("ui_pause") or Input.is_action_just_pressed("ui_back"):
		return State.Paused
	
	return State.Null

func state_check() -> BaseMenu:
	return State.Null

func back_button_pressed() -> void:
	EventBus.emit_signal("menuChanged", State.Paused)


func menu_hid() -> void:
	for child in settingsContainer.get_children():
		child.visible = false 

func show_gameplay() -> void:
	menu_hid()
	gameplayMenu.visible = true

func show_accessibility() -> void:
	menu_hid()
	accessibilityMenu.visible = true

func show_video() -> void:
	menu_hid()
	videoMenu.visible = true

func show_audio() -> void:
	menu_hid()
	audioMenu.visible = true

func show_keybindings() -> void:
	menu_hid()
	keybindingMenu.visible = true

