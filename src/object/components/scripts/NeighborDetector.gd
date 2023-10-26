extends Area2D
class_name NeighborDetectorComponent


@onready var parent: Node = get_parent()
@onready var parentType: String = parent.get_script().resource_path.get_file()

var neighbors: Array 


func _ready() -> void:
	await get_tree().process_frame
	get_neighbors()
	


func reset() -> void:
	pass #LOOKAT: might crash if reset afterwards
#	neighbors.clear()
#	await get_tree().process_frame
#	get_neighbors()


func get_neighbors() -> void:
	for i in get_overlapping_bodies():
		if i.get_script().resource_path.get_file() == parentType and i != parent:
#			print(str(parent) + " is touch " + str(i))
			neighbors.append(i)
