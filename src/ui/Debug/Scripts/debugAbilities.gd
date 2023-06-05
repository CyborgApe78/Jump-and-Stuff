extends Control


@export var buttonAbilityAll: Button
@export var buttonJumpAll: Button
@export var buttonJumpAir: Button
@export var buttonJumpConsec: Button
@export var buttonDashAll: Button
@export var buttonDashSide: Button
@export var buttonDashUp: Button
@export var buttonDashDown: Button
@export var buttonDashWall: Button
@export var buttonDashClimb: Button
@export var buttonDashJump: Button
@export var buttonSlide: Button
@export var buttonDashDownBounce: Button
@export var buttonGlide: Button
@export var buttonDive: Button
@export var buttonGrappleHook: Button
@export var consecAmount: OptionButton
#TODO: change to signals once the player has all ability, stats, and upgrade checks
var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	buttonJumpAir.button_pressed = Abilities.unlockedJumpAir
	buttonJumpConsec.button_pressed = Abilities.unlockedJumpConsec
	buttonDashSide.button_pressed = Abilities.unlockedDashSide
	buttonDashUp.button_pressed = Abilities.unlockedDashUp
	buttonDashDown.button_pressed = Abilities.unlockedDashDown
	buttonDashWall.button_pressed = Abilities.unlockedDashWall
	buttonDashClimb.button_pressed = Abilities.unlockedDashClimb
	buttonDashJump.button_pressed = Abilities.unlockedDashJump
	buttonSlide.button_pressed = Abilities.unlockedSlide
	buttonDashDownBounce.button_pressed = Abilities.unlockedDashDownBounce
	buttonGlide.button_pressed = Abilities.unlockedGlide
	buttonDive.button_pressed = Abilities.unlockedDive
	buttonGrappleHook.button_pressed = Abilities.unlockedGrappleHook
	
	consecAmount.selected = Abilities.maxJumpConsec -1


func _on_all_toggled(button_pressed: bool) -> void:
	buttonJumpAll.button_pressed = button_pressed
	buttonDashAll.button_pressed = button_pressed
	buttonSlide.button_pressed = button_pressed
	buttonDashDownBounce.button_pressed = button_pressed
	buttonGlide.button_pressed = button_pressed
	buttonDive.button_pressed = button_pressed
	buttonGrappleHook.button_pressed = button_pressed


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
	buttonDashWall.button_pressed = button_pressed
	buttonDashClimb.button_pressed = button_pressed
	buttonDashJump.button_pressed = button_pressed


func _on_dash_side_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashSide, button_pressed)


func _on_dash_up_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashUp, button_pressed)


func _on_dash_down_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashDown, button_pressed)


func _on_dash_wall_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashWall, button_pressed)


func _on_dash_climb_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashClimb, button_pressed)


func _on_dash_jump_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashJump, button_pressed)


func _on_slide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Slide, button_pressed)


func _on_ground_pound_bounce_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashDownBounce, button_pressed)


func _on_glide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Glide, button_pressed)


func _on_dive_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Dive, button_pressed)


func _on_grapple_hook_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GrappleHook, button_pressed)
