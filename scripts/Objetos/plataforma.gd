extends StaticBody2D

# Variables exportadas para ajustar el desplazamiento y velocidad de la plataforma
@export var desplazamiento: Vector2 = Vector2(0, 0)  # Distancia total que se moverá la plataforma
@export var velocidad: float = 55.0  # Velocidad de movimiento de la plataforma
@export var repetir: bool = true  # Si la plataforma debe moverse de ida y vuelta

# Referencias a nodos
@onready var areaPlataforma = $Area2D  # Área de detección para jugadores sobre la plataforma

# Puntos de inicio y fin del recorrido de la plataforma
var punto_inicio: Vector2
var punto_final: Vector2
var destino: Vector2  # Punto al que la plataforma se dirige

func _ready() -> void:
	# Se establecen los puntos de inicio y final de la plataforma
	punto_inicio = position
	punto_final = punto_inicio + desplazamiento
	destino = punto_final  # La plataforma inicia moviéndose hacia el punto final

func _process(delta: float) -> void:
	# Guarda la posición anterior antes de moverse
	var last_position = position
	
	# Mueve la plataforma gradualmente hacia el destino
	position = position.move_toward(destino, velocidad * delta)
	
	# Calcula el desplazamiento que ha ocurrido en este frame
	var desplazamiento_local = position - last_position

	# Si la plataforma llega al destino, invierte la dirección de movimiento
	if position.is_equal_approx(destino):
		destino = punto_inicio if destino == punto_final else punto_final

	# Ajusta la posición de los jugadores que están sobre la plataforma
	_mover_jugadores_encima(desplazamiento_local)

func _mover_jugadores_encima(movimiento: Vector2):
	# Recorre todos los cuerpos que están sobre la plataforma
	for body in areaPlataforma.get_overlapping_bodies():
		# Solo afecta a los jugadores que están tocando el suelo (evita problemas al saltar)
		if body.is_in_group("jugador") and body.is_on_floor():
			# Ajusta la posición del jugador para que se mueva junto con la plataforma
			body.position += movimiento
