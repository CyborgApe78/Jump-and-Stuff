extends Area2D
class_name Interactable


@export var oneUse: bool = false
@export var lockOut: bool = false
@export var lockOutTime: float = 4.0
@export var lockoutTimer: Timer


func _ready() -> void:
	lockoutTimer.wait_time = lockOutTime
	body_entered.connect(_on_Interactable_entered)
	if oneUse and lockOut:
		EventBus.error.emit(str("Interactable block oneUse and lockOut selected: " + str(name) + " at " + str(global_position)))


func lock_out() -> void:
	var currentColor = modulate
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	modulate = Color.DARK_GRAY
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	modulate = currentColor


func _on_Interactable_entered(body: Player) -> void:
	if oneUse:
		queue_free()
	elif lockOut:
		lock_out()
