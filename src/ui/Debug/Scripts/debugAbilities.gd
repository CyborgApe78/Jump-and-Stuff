extends Control


@export var buttonAbilityAll: Button
@export var buttonJumpAll: Button
@export var buttonJumpAir: Button
@export var buttonJumpConsec: Button
@export var buttonDashAll: Button
@export var buttonDashSide: Button
@export var buttonDashUp: Button
@export var buttonDashDown: Button
@export var buttonGroundPound: Button
@export var buttonGlide: Button
@export var buttonDive: Button

@export var consecAmount: OptionButton

var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	consecAmount.selected = Abilities.maxJumpConsec -1
	buttonJumpAir.button_pressed = Abilities.unlockedJumpAir
	buttonJumpConsec.button_pressed = Abilities.unlockedJumpConsec
	buttonDashSide.button_pressed = Abilities.unlockedDashSide
	buttonDashUp.button_pressed = Abilities.unlockedDashUp
	buttonDashDown.button_pressed = Abilities.unlockedDashDown
	buttonGroundPound.button_pressed = Abilities.unlockedGroundPound
	buttonGlide.button_pressed = Abilities.unlockedGlide
	buttonDive.button_pressed = Abilities.unlockedDive


func _on_all_toggled(button_pressed: bool) -> void:
	buttonJumpAll.button_pressed = button_pressed
	buttonDashAll.button_pressed = button_pressed
	buttonGroundPound.button_pressed = button_pressed
	buttonGlide.button_pressed = button_pressed
	buttonDive.button_pressed = button_pressed


func _on_jump_all_toggled(button_pressed: bool) -> void:
	buttonJumpAir.button_pressed = button_pressed
	buttonJumpConsec.button_pressed = button_pressed


func _on_jump_air_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpAir, button_pressed)


func _on_jump_consec_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpConsec, button_pressed)


func _on_jump_consec_amount_item_selected(index: int) -> void: #TODO: move to stats
	Abilities.maxJumpConsec = index + 1


func _on_dash_all_toggled(button_pressed: bool) -> void:
	buttonDashSide.button_pressed = button_pressed
	buttonDashUp.button_pressed = button_pressed
	buttonDashDown.button_pressed = button_pressed


func _on_dash_side_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashSide, button_pressed)


func _on_dash_up_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashUp, button_pressed)


func _on_dash_down_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashDown, button_pressed)


func _on_ground_pound_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GroundPound, button_pressed)


func _on_glide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Glide, button_pressed)


func _on_dive_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Dive, button_pressed)
