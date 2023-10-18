extends Area2D
class_name ActorCounterComponent

## tracks the number of actors in an area

signal cleared
signal entered

@onready var parent:= get_parent()

@export var labelCount: Label

var bodiesOn: int = 0:
	set(v):
		bodiesOn = max(v, 0)
		labelCount.text = str(bodiesOn)
		if bodiesOn == 0:
			cleared.emit()


func _ready() -> void:
	reset()


func _process(delta: float) -> void:
	pass


func reset() -> void:
	bodiesOn = 0
	#LOOKAT: might need to look at overlapping bodies to see if something is there when spawning


func _on_body_entered(body: Actor) -> void:
	if parent.visible and body.position.y < position.y:
		entered.emit()
		bodiesOn += 1


func _on_body_exited(body: Actor) -> void:
	if parent.visible and body.position.y < position.y:
		bodiesOn -= 1.
