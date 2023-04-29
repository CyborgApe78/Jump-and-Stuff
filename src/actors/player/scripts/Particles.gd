extends Node2D
#TODO: landed particles need to be based on velocity
#TODO: turn particles into scenes and color is set when called, us func emit_particles(particle, color) 

@export var walk: GPUParticles2D
@export var skid: GPUParticles2D
@export var land: GPUParticles2D
@export var jump: GPUParticles2D
@export var jumpDouble: GPUParticles2D
@export var jumpTriple: GPUParticles2D
@export var dash: GPUParticles2D
@export var wallSlide: GPUParticles2D
@export var WallClimb: GPUParticles2D
@export var jumpWall: GPUParticles2D

@onready var player = get_parent().get_parent().get_parent()

func _ready() -> void:
	dash.process_material.color = AbilityColor.dashSideColor
	check_ground_color()

func check_ground_color() -> void:
	walk.process_material.color = player.groundColor
	skid.process_material.color = player.groundColor
	land.process_material.color = player.groundColor
	jump.process_material.color = player.groundColor
	jumpDouble.process_material.color = player.groundColor
	jumpTriple.process_material.color = player.groundColor
