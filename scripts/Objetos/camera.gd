extends Camera2D

@onready var player = $"../personaje"

func _physics_process(delta):
	var target_x = player.global_position.x
	var current_y = global_position.y 
	
	var smoothing_speed = 0.1 
	var new_position = Vector2(
		lerp(global_position.x, target_x, smoothing_speed),
		current_y
	)
	global_position = new_position
