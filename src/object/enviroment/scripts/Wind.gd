extends EnviromentalEffects
#TODO: look into 9patchrec
@onready var collisionShape: CollisionShape2D = $CollisionShape2D
@onready var particles: GPUParticles2D = $GPUParticles2D
var windVelocity: Vector2

func _ready() -> void:
	if direction == directions.Null:
		EventBus.error.emit(str("wind direction null: " + str(name) + " at " + str(global_position)))
	adjust_particle()
	windVelocity =  Vector2(0,-strength).rotated(rotation)

func adjust_particle():
	particles.process_material.emission_box_extents.x = collisionShape.shape.extents.x
#	particles.lifetime = 
#	particles.amount = 
#	particles.process_material.scale =
#	particles.process_material.initial_velocity =
#TODO: scaling various parts based on size
	
#	particles.process_material.scale = 1/SCALE
#	particles.process_material.initial_velocity = strength * SPEED
#	particles.amount = ceil(scale.x * scale.y * SCALE) + 8
	pass

func enter_wind(body: Actor) -> void:
	body.inWind = true
	body.windVelocity = windVelocity


func exit_wind(body: Actor) -> void:
	body.inWind = false
	body.windVelocity = Vector2.ZERO

