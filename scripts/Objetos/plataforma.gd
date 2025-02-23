extends StaticBody2D

@export var desplazamiento: Vector2 = Vector2(0, 0)
@export var velocidad: float = 55.0

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

	var desplazamiento = position - last_position

	if position.is_equal_approx(destino):
		if destino == punto_final:
			destino = punto_inicio
		else:
			destino = punto_final

	_mover_personajes_encima(desplazamiento)

func _mover_personajes_encima(desplazamiento: Vector2):

	for body in $Area2D.get_overlapping_bodies():
		if body is CharacterBody2D:
			if body.is_on_floor():
				body.position += desplazamiento
