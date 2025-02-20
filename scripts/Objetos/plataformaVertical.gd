extends CharacterBody2D

@export var empieza_abajo: bool = false
var speed = 50
var direction: int = -1
var vertical_distance = 50
var initial_position: Vector2 = Vector2.ZERO

func _ready():
	initial_position = position

	if empieza_abajo:
		position.y = initial_position.y
		direction = -1 # Subir
	else:
		position.y = initial_position.y - vertical_distance
		direction = 1 # Bajar

func _physics_process(delta):
	position.y += speed * direction * delta

	if position.y <= initial_position.y - vertical_distance:
		position.y = initial_position.y - vertical_distance
		direction = 1

	elif position.y >= initial_position.y:
		position.y = initial_position.y
		direction = -1
