extends EnviromentalEffects
#extends Fluids #TODO: create class

#TODO: look into 9patchrec
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var background: ColorRect = $ColorRect
var windVelocity: Vector2

#TODO: poison, lava, freeze


func _ready() -> void:
	adjust_particle()


func adjust_particle():
	particles.process_material.emission_box_extents.x = collisionShape.shape.extents.x
	background.size = collisionShape.shape.size


func enter_water(body: Actor) -> void:
	body.inWater = true


func exit_water(body: Actor) -> void:
	body.inWater = false
