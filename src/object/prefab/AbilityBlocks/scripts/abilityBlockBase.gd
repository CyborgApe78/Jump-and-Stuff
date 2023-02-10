extends Interactable
class_name AbilityBlockBase
#TODO: add collision layers for abilities

@onready var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
@export var ability: PlayerAbilities.list
var blockColor: Color


func _ready() -> void:
	super._ready()
	block_color()


func block_color() -> void:
	if ability == PlayerAbilities.list.All:
		modulate = AbilityColor.allColor
	elif ability == PlayerAbilities.list.JumpAir:
		modulate = AbilityColor.jumpColor
	elif ability == PlayerAbilities.list.DashSide:
		modulate = AbilityColor.dashSideColor
	elif ability == PlayerAbilities.list.DashUp:
		modulate = AbilityColor.dashUpColor
	elif ability == PlayerAbilities.list.DashDown:
		modulate = AbilityColor.dashDownColor
#	elif ability == PlayerAbilities.list.Grapple:
#		blockColor = AbilityColor.grappleColor
	elif ability == PlayerAbilities.list.SwimDash:
		modulate = AbilityColor.swimDashColor
	elif ability == PlayerAbilities.list.Burrow:
		modulate = AbilityColor.burrowColor
#	elif ability == PlayerAbilities.list.Pogo:
#		blockColor = AbilityColor.pogoColor
#	elif ability == PlayerAbilities.list.Spin:
#		blockColor = AbilityColor.spinColor
#	elif ability == PlayerAbilities.list.Bash:
#		blockColor = AbilityColor.bashColor
	else:
		print("null color " + str(self.name) + " " + str(global_position))
