extends Control

@export var radio_maximo: float = 50.0  # Distancia máxima que se puede mover el joystick
var direccion: Vector2 = Vector2.ZERO  # Dirección del movimiento

@onready var knob = $JoystickKnob  # Referencia al "stick" del joystick
var posicion_inicial: Vector2  # Posición original del joystick

func _ready():
	posicion_inicial = knob.position

func _input(event):
	if event is InputEventScreenTouch or event is InputEventScreenDrag:
		var distancia = (event.position - position).length()

		# Si la entrada está dentro del área del joystick
		if distancia < radio_maximo * 2:
			if event is InputEventScreenTouch and event.pressed:
				_mover_knob(event.position)

			elif event is InputEventScreenDrag:
				_mover_knob(event.position)

		# Cuando se suelta el dedo, el joystick regresa al centro
		if event is InputEventScreenTouch and not event.pressed:
			_resetear_joystick()

func _mover_knob(posicion_tactil: Vector2):
	var vector_mov = (posicion_tactil - position).limit_length(radio_maximo)
	knob.position = posicion_inicial + vector_mov
	direccion = vector_mov.normalized()

	# Enviar los inputs de movimiento
	Input.action_release("move_left")
	Input.action_release("move_right")

	if direccion.x < -0.2:
		Input.action_press("move_left")
	elif direccion.x > 0.2:
		Input.action_press("move_right")

func _resetear_joystick():
	knob.position = posicion_inicial
	direccion = Vector2.ZERO
	Input.action_release("move_left")
	Input.action_release("move_right")
