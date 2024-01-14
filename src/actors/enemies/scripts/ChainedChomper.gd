extends Enemies

#TODO: player can break base

@export var speed: int = 200
@export var gravity: int = 100

@export var timeCharge: float = 2.0
@export var timerCharge: Timer

@export var timeHold: float = 1
@export var timerHold: Timer

@export var labelState: Label
@export var labelVelocity: Label

var currentState: int
enum state { #TODO: add patrol state
	rest,
	charge,
	fall,
}


func _ready() -> void:
	timerCharge.wait_time = timeCharge
	change_to_rest()


func _physics_process(delta: float) -> void:
	labelVelocity.text = str(velocity)
	match currentState:
		state.rest:
			pass
		state.charge:
			pass
		state.fall:
			velocity.y += gravity * delta
			if is_on_floor():
				change_to_rest()
	
	move_and_slide()


func change_to_rest() -> void:
	timerCharge.start()
	currentState = state.rest
	labelState.text = str(state.rest)


func change_to_charge() -> void:
	velocity = Vector2(randf_range(-1, 1),randf_range(-1, 1)) * speed
	currentState = state.charge
	labelState.text = str(state.charge)
	timerHold.start()


func change_to_fall() -> void:
	velocity= Vector2.ZERO
	currentState = state.fall
	labelState.text = str(state.fall)


func _on_charge_t_imer_timeout() -> void:
	change_to_charge()


func _on_hold_timeout() -> void:
	change_to_fall()
