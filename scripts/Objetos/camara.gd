extends Camera2D

# Referencia al nodo del personaje, asignado automáticamente al iniciar la escena
@onready var player = $"../personaje"

func _physics_process(_delta):
	# Obtiene la posición X global del personaje para seguirlo en el eje horizontal
	var target_x = player.global_position.x
	
	# Mantiene la posición actual en el eje Y para evitar movimientos verticales
	var current_y = global_position.y 
	
	# Define la velocidad de suavizado de la cámara al seguir al personaje
	var smoothing_speed = 0.1 
	
	# Calcula la nueva posición usando interpolación lineal (lerp) para un seguimiento suave
	var new_position = Vector2(
		lerp(global_position.x, target_x, smoothing_speed),
		current_y
	)
	
	# Aplica la nueva posición a la cámara
	global_position = new_position
