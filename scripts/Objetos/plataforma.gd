extends StaticBody2D

@export var desplazamiento: Vector2 = Vector2(0, 0)  # Variable global
@export var velocidad: float = 55.0
@export var repetir: bool = true

@onready var areaPlataforma = $Area2D
var punto_inicio: Vector2
var punto_final: Vector2
var destino: Vector2

func _ready() -> void:
	punto_inicio = position
	punto_final = punto_inicio + desplazamiento
	destino = punto_final

func _process(delta: float) -> void:
	var last_position = position

	position = position.move_toward(destino, velocidad * delta)
	var desplazamiento_local = position - last_position

	if position.is_equal_approx(destino):
		destino = punto_inicio if destino == punto_final else punto_final

	_mover_jugadores_encima(desplazamiento_local)

func _mover_jugadores_encima(movimiento: Vector2):
	for body in areaPlataforma.get_overlapping_bodies():
		if body.is_in_group("jugador") and body.is_on_floor():
			body.position += movimiento
