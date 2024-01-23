extends Area2D
class_name Projectile

#TODO: add as a bashable target

@export_group("Connections")
@export var hurtbox: HurtBox

@export_group("")
@export var damage: int = 1:
	set(v):
		damage = v
		set_damage()

@export var speed: int = 200
var currentSpeed: int

var direction: Vector2 = Vector2.ZERO

var currentState: int
enum  states {
	idle,
	moving,
	collide
}


func _ready() -> void:
	set_damage()
	currentSpeed = speed
	EventBus.timeFreeze.connect(stop_time)


func _physics_process(delta: float) -> void:
	position += direction * currentSpeed * delta


func set_damage() -> void:
	if not hurtbox == null:
		hurtbox.damage = damage


func _on_body_entered(body: Node2D) -> void:
	if not body is Turrets:
		queue_free()


func stop_time(v: bool) -> void:
	if v:
		currentSpeed = 0
	else:
		currentSpeed = speed
