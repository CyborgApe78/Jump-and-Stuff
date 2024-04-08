extends Camera2D
#TODO: extends: PhantomCamera2D

func _on_tree_entered() -> void:
	make_current()

#TODO: add screen shake
#TODO: draw thresholds on screen
#TODO: area check for other important objects, split player and objects into view
#Notes:
# have base of camera certain number of tiles below player. don't move in air, unless passing threshold
# speedup-push-zone: another threshold where the camera slowing speeds up to player, then matches speed
# threshold before switching moving the camera in the oposite direction
# use the aim direction to adjust the camera


#LOOKAT: Little Runmo camera
