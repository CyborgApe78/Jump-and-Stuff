class_name PlayerIdle extends MachineState


@export_group("States")
@export var Walk: PlayerWalk
@export var Jump: PlayerJump
@export var Fall: PlayerFall


func ready() -> void:
	pass


func enter() -> void:
	print("Idle")
	if inputs.canBufferJump == true:
		print("buffer Jump")
		FSM.change_state_to(Jump) #TODO: jump manager to decide which
	player.facing_logic(inputs.lastMoveDirection.x)
	characterRig.speed_bend_reset(transformTime)
	player.velocity.y = 0


func exit(_next_state: MachineState) -> void:
	pass


func handle_input(_event: InputEvent):
	if Input.is_action_just_pressed("jump"):
		FSM.change_state_to(Jump)


func physics_update(_delta: float):
	pass


func state_update(_delta: float):
	if inputs.moveDirection.x != 0:
		FSM.change_state_to(Walk)
	if not player.is_on_floor():
		inputs.leave_ground()
		FSM.change_state_to(Fall)


func visual_update(_delta: float):
	pass


func sound_update(_delta: float):
	pass
