extends Enviromental
class_name Water

#extends Fluids #TODO: create class
#TODO: make color rect get size off of collisionshape
#TODO: remove collision and add it 

#TODO: look into 9patchrec
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
@onready var background: ColorRect = $ColorRect
var windVelocity: Vector2

#TODO: poison, lava, freeze


func _ready() -> void:
	set_collision_layer_value(CollisionLayers.FLUID, true)
	adjust_particle()


func adjust_particle():
	particles.process_material.emission_box_extents.x = collisionShape.shape.extents.x
	background.size = collisionShape.shape.size


func enter_water(body: Actor) -> void:
	body.inWater = true


func exit_water(body: Actor) -> void:
	body.inWater = false
