extends Control


@export var buttonAbilityAll: Button
@export var buttonJumpAll: Button
@export var buttonJumpAir: Button
@export var buttonJumpFlip: Button
@export var buttonJumpLong: Button
@export var buttonJumpCrouch: Button
@export var buttonJumpGroundPound: Button
@export var buttonJumpWall: Button
@export var buttonJumpRoll: Button
@export var buttonJumpBelly: Button
@export var buttonJumpConsec: Button
@export var buttonDashAll: Button
@export var buttonDashSide: Button
@export var buttonDashUp: Button
@export var buttonDashDown: Button
@export var buttonDashGround: Button
@export var buttonDashWall: Button
@export var buttonDashClimb: Button
@export var buttonDashJump: Button
@export var buttonDashGroundPound: Button
@export var buttonDashRoll: Button
@export var buttonDashBelly: Button
@export var buttonOtherAll: Button
@export var buttonSlide: Button
@export var buttonGroundPound: Button
@export var buttonGroundPoundBounce: Button
@export var buttonWallGrab: Button
@export var buttonGrappleHook: Button
@export var buttonBash: Button
@export var buttonSpin: Button
@export var buttonRoll: Button
@export var buttonBurrow: Button
@export var buttonGlide: Button
@export var buttonDive: Button
@export var buttonSwimDash: Button
@export var consecAmount: OptionButton
@export var dashAmount: OptionButton
#TODO: change to signals once the player has all ability, stats, and upgrade checks

var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
var Stats: Resource = preload("res://src/actors/player/resources/playerStats.tres")


func _ready() -> void:
	EventBus.debugMenuOpened.connect(check)


func check(BOOL) -> void:
	buttonJumpAir.button_pressed = Abilities.unlockedJumpAir
	buttonJumpFlip.button_pressed = Abilities.unlockedJumpFlip
	buttonJumpLong.button_pressed = Abilities.unlockedJumpLong
	buttonJumpCrouch.button_pressed = Abilities.unlockedJumpCrouch
	buttonJumpGroundPound.button_pressed = Abilities.unlockedJumpGroundPound
	buttonJumpWall.button_pressed = Abilities.unlockedJumpWall
	buttonJumpRoll.button_pressed = Abilities.unlockedJumpRoll
	buttonJumpBelly.button_pressed = Abilities.unlockedJumpBelly
	buttonJumpConsec.button_pressed = Abilities.unlockedJumpConsec
	buttonDashSide.button_pressed = Abilities.unlockedDashSide
	buttonDashUp.button_pressed = Abilities.unlockedDashUp
	buttonDashDown.button_pressed = Abilities.unlockedDashDown
	buttonDashGround.button_pressed = Abilities.unlockedDashGround
	buttonDashWall.button_pressed = Abilities.unlockedDashWall
	buttonDashClimb.button_pressed = Abilities.unlockedDashClimb
	buttonDashJump.button_pressed = Abilities.unlockedDashJump
	buttonDashGroundPound.button_pressed = Abilities.unlockedDashGroundPound
	buttonDashRoll.button_pressed = Abilities.unlockedDashRoll
	buttonDashBelly.button_pressed = Abilities.unlockedDashBelly
	buttonSlide.button_pressed = Abilities.unlockedSlide
	buttonGroundPound.button_pressed = Abilities.unlockedGroundPound
	buttonGroundPoundBounce.button_pressed = Abilities.unlockedGroundPoundBounce
	buttonWallGrab.button_pressed = Abilities.unlockedWallGrab
	buttonGrappleHook.button_pressed = Abilities.unlockedGrappleHook
	buttonBash.button_pressed = Abilities.unlockedBash
	buttonSpin.button_pressed = Abilities.unlockedSpin
	buttonRoll.button_pressed = Abilities.unlockedRoll
	buttonBurrow.button_pressed = Abilities.unlockedBurrow
	buttonGlide.button_pressed = Abilities.unlockedGlide
	buttonDive.button_pressed = Abilities.unlockedDive
	buttonSwimDash.button_pressed = Abilities.unlockedSwimDash
	
	consecAmount.selected = Abilities.maxJumpConsec -1
	dashAmount.selected = Abilities.maxDash -1


func _on_all_toggled(button_pressed: bool) -> void:
	buttonJumpAll.button_pressed = button_pressed
	buttonDashAll.button_pressed = button_pressed
	buttonOtherAll.button_pressed = button_pressed


func _on_jump_all_toggled(button_pressed: bool) -> void:
	buttonJumpAir.button_pressed = button_pressed
	buttonJumpFlip.button_pressed = button_pressed
	buttonJumpLong.button_pressed = button_pressed
	buttonJumpCrouch.button_pressed = button_pressed
	buttonJumpGroundPound.button_pressed = button_pressed
	buttonJumpWall.button_pressed = button_pressed
	buttonJumpRoll.button_pressed = button_pressed
	buttonJumpBelly.button_pressed = button_pressed
	buttonJumpConsec.button_pressed = button_pressed


func _on_jump_air_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpAir, button_pressed)


func _on_jump_flip_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpFlip, button_pressed)


func _on_jump_long_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpLong, button_pressed)


func _on_jump_crouch_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpCrouch, button_pressed)


func _on_jump_ground_pound_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpGroundPound, button_pressed)


func _on_jump_wall_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpWall, button_pressed)


func _on_jump_roll_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpRoll, button_pressed)


func _on_jump_belly_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpBelly, button_pressed)


func _on_jump_consec_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.JumpConsec, button_pressed)


func _on_jump_consec_amount_item_selected(index: int) -> void:
	Abilities.maxJumpConsec = index + 1


func _on_dash_all_toggled(button_pressed: bool) -> void:
	buttonDashSide.button_pressed = button_pressed
	buttonDashUp.button_pressed = button_pressed
	buttonDashDown.button_pressed = button_pressed
	buttonDashGround.button_pressed = button_pressed
	buttonDashWall.button_pressed = button_pressed
	buttonDashClimb.button_pressed = button_pressed
	buttonDashJump.button_pressed = button_pressed
	buttonDashGroundPound.button_pressed = button_pressed
	buttonDashRoll.button_pressed = button_pressed
	buttonDashBelly.button_pressed = button_pressed


func _on_dash_side_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashSide, button_pressed)


func _on_dash_up_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashUp, button_pressed)


func _on_dash_down_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashDown, button_pressed)


func _on_dash_ground_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashGround, button_pressed)


func _on_dash_wall_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashWall, button_pressed)


func _on_dash_climb_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashClimb, button_pressed)


func _on_dash_jump_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashJump, button_pressed)


func _on_dash_ground_pound_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashGroundPound, button_pressed)


func _on_dash_roll_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashRoll, button_pressed)


func _on_dash_belly_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.DashBelly, button_pressed)


func _on_dash_amount_item_selected(index: int) -> void:
	Abilities.maxDash = index + 1


func _on_other_all_toggled(button_pressed: bool) -> void:
	buttonSlide.button_pressed = button_pressed
	buttonGroundPound.button_pressed = button_pressed
	buttonGroundPoundBounce.button_pressed = button_pressed
	buttonWallGrab.button_pressed = button_pressed
	buttonGrappleHook.button_pressed = button_pressed
	buttonBash.button_pressed = button_pressed
	buttonSpin.button_pressed = button_pressed
	buttonRoll.button_pressed = button_pressed
	buttonBurrow.button_pressed = button_pressed
	buttonGlide.button_pressed = button_pressed
	buttonDive.button_pressed = button_pressed
	buttonSwimDash.button_pressed = button_pressed


func _on_slide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Slide, button_pressed)


func _on_ground_pound_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GroundPound, button_pressed)


func _on_ground_pound_bounce_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GroundPoundBounce, button_pressed)


func _on_wall_grab_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.WallGrab, button_pressed)


func _on_grapple_hook_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.GrappleHook, button_pressed)


func _on_bash_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Bash, button_pressed)


func _on_spin_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Spin, button_pressed)


func _on_roll_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Roll, button_pressed)


func _on_burrow_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Burrow, button_pressed)


func _on_glide_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Glide, button_pressed)


func _on_dive_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.Dive, button_pressed)


func _on_swim_dash_toggled(button_pressed: bool) -> void:
	Abilities.unlock(PlayerAbilities.list.SwimDash, button_pressed)
