extends Node2D
#TODO: landed particles need to be based on velocity
#TODO: export all particles for states

@export var walk: GPUParticles2D
@export var skid: GPUParticles2D
@export var land: GPUParticles2D
@export var jump: GPUParticles2D
@export var jumpDouble: GPUParticles2D
@export var jumpTriple: GPUParticles2D
@export var dash: GPUParticles2D
@export var dashUp: GPUParticles2D
@export var dashDown: GPUParticles2D
@export var wallSlide: GPUParticles2D
@export var WallClime: GPUParticles2D
@export var jumpWall: GPUParticles2D

@onready var player = get_parent().get_parent().get_parent()

func _ready() -> void:
	dash.process_material.color = AbilityColor.dashSideColor
	dashUp.process_material.color = AbilityColor.dashUpColor
	dashDown.process_material.color = AbilityColor.dashDownColor

func _process(delta: float) -> void:
	walk.process_material.color = player.groundColor
	skid.process_material.color = player.groundColor
	land.process_material.color = player.groundColor
	jump.process_material.color = player.groundColor
	jumpDouble.process_material.color = player.groundColor
	jumpTriple.process_material.color = player.groundColor
