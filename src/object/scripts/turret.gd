extends StaticBody2D

#TODO: add limits of bullets
#TODO: make time freeze state 

@export var projectile: PackedScene #TODO: change to projectile type
@export var rotateBlock: bool = false

@export_group("Connections")
@export var shootPosition: Marker2D
@export var timerShoot: Timer
@export var timerReload: Timer
@export var directionCast: RayCast2D

@export_group("")
@export var timeShoot: float = 1.0

var bullet: Projectile
var shootDirection: Vector2 = Vector2.ZERO


func _ready() -> void:
	timerShoot.wait_time = timeShoot
	timerReload.wait_time = timeShoot
	
	if projectile == null:
		EventBus.error.emit(name + " at " + str(global_position) + " is null")
		return
	prepare_to_shoot()


func _physics_process(delta: float) -> void:
	if rotateBlock: #FIXME: bullet doesn't line up correctly
		rotate(.1)


func prepare_to_shoot() -> void: #TODO: make it move to front
	bullet = projectile.instantiate()
	bullet.position = shootPosition.position
	shootPosition.add_child(bullet)
	timerShoot.start()


func shoot() -> void:
	bullet.direction = shoot_direction()


func _on_shoot_timeout() -> void:
	shoot()
	bullet.reparent(get_parent())
	timerReload.start()


func shoot_direction() -> Vector2:
	var rGlobalOrigin = directionCast.to_global(Vector2.ZERO)
	var rGlobalCastToEndpoint = directionCast.to_global(directionCast.target_position)
	shootDirection = rGlobalCastToEndpoint - rGlobalOrigin
	shootDirection.x = signi(shootDirection.x)
	shootDirection.y = signi(shootDirection.y)
	
	return shootDirection


func _on_reload_timeout() -> void:
	prepare_to_shoot()
