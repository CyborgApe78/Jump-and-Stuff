extends Marker2D

#TODO: make this work

#var angleConeOfVision: float = deg_to_rad(30.0)
#var maxViewDistance: int = 4 * Util.tileSize
#var angleBetweenRays: float = deg_to_rad(5.0)
#
#var target
#
#func generate_raycasts() -> void:
	#var rayCount: float = angleConeOfVision / angleBetweenRays
	#
	#for i in rayCount:
		#var ray: RayCast2D = RayCast2D.new()
		#var angle: float = angleBetweenRays * (i - rayCount / 2.0)
		#ray.target_position = Vector2.UP.rotated(angle) * maxViewDistance
		#add_child(ray)
		#ray.enabled = true
#
#func _physics_process(delta: float) -> void:
	#for ray: RayCast2D in get_children():
		#if ray.is_colliding() and ray.get_collider() is Player:
			#target = ray.get_collider()
			#break
