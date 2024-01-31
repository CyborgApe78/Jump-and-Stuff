extends Interactable
class_name AbilityBlockBase
#TODO: add collision layers for abilities

@onready var Abilities: Resource = preload("res://src/actors/player/resources/playerAbilities.tres")
@export var ability: PlayerAbilities.listAbilityBlock #TODO: convert blocks to listAbilityBlock
var blockColor: Color


func _ready() -> void:
	super._ready()
	block_color()


func block_color() -> void:
	if ability == PlayerAbilities.list.DashSide:
		modulate = GameColor.dashSideColor
	elif ability == PlayerAbilities.list.DashUp:
		modulate = GameColor.dashUpColor
	elif ability == PlayerAbilities.list.DashDown:
		modulate = GameColor.dashDownColor
#	elif ability == PlayerAbilities.list.Grapple:
#		blockColor = GameColor.grappleColor
	elif ability == PlayerAbilities.list.Burrow:
		modulate = GameColor.burrowColor
#	elif ability == PlayerAbilities.list.Pogo:
#		blockColor = GameColor.pogoColor
#	elif ability == PlayerAbilities.list.Spin:
#		blockColor = GameColor.spinColor
#	elif ability == PlayerAbilities.list.Bash:
#		blockColor = GameColor.bashColor
	else:
		EventBus.error.emit("null color " + str(self.name) + " " + str(global_position))
