extends Area2D
class_name ActorCounterComponent

## tracks the number of actors in an area
#TODO: get size and position of parent and set the area above

signal cleared
signal entered

@onready var parent:= get_parent()

@export var labelCount: Label
@export var collision: CollisionShape2D

var bodiesOn: int = 0:
	set(v):
		bodiesOn = max(v, 0)
		labelCount.text = str(bodiesOn)
		if bodiesOn == 0:
			cleared.emit()


func _ready() -> void:
	reset()


func reset() -> void:
	if get_overlapping_areas().is_empty():
			bodiesOn = 0 
	else:
		for i in get_overlapping_areas():
			bodiesOn += 1


func _on_area_entered(area: PlatformCheckerComponent) -> void:
	if parent.visible:
		entered.emit()
		for i in get_overlapping_areas():
			bodiesOn += 1


func _on_area_exited(area: PlatformCheckerComponent) -> void:
	if parent.visible:
		if get_overlapping_areas().is_empty():
			bodiesOn = 0 
		else:
			for i in get_overlapping_areas():
				bodiesOn += 1
