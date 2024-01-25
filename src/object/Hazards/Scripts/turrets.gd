extends StaticBody2D
class_name Turrets

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
@export var timeReload: float = 0.5

var bullet: Projectile
var shootDirection: Vector2 = Vector2.ZERO

signal reloaded
signal fired


func _ready() -> void:
	timerShoot.wait_time = timeShoot
	timerReload.wait_time = timeReload
	
	if projectile == null:
		EventBus.error.emit(name + " at " + str(global_position) + " is null")
		return
	
	reload()


func _physics_process(delta: float) -> void:
	if rotateBlock: #FIXME: bullet doesn't line up correctly
		rotate(.1)


func reload() -> void:
	bullet = projectile.instantiate()
	bullet.hurtbox.set_deferred("monitoring", false)
	bullet.position = Vector2(8,0)
	shootPosition.add_child(bullet)
	
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(bullet, "position", Vector2(shootPosition.position.x, shootPosition.position.y), 0.5).from_current()
	tween.tween_callback(reload_finished).finished
	


func reload_finished() -> void:
	reloaded.emit()


func prepare_to_shoot() -> void: 
	timerShoot.start()


func shoot() -> void:
	bullet.direction = shoot_direction()
	fired.emit()


func _on_shoot_timeout() -> void:
	bullet.hurtbox.set_deferred("monitoring", true)
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
	reload()


func time_freeze(v: bool) -> void:
	pass
