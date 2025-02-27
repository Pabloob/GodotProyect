extends Control

# Referencias a los botones de acción dentro del nodo 'Botones'
@onready var boton_saltar = $Botones/Saltar
@onready var boton_atacar = $Botones/Atacar

# Configuración visual y parámetros de sensibilidad del joystick táctil
@export var color_presionado := Color.GRAY  # Color cuando el joystick es presionado
@export_range(0, 200, 1) var zona_sin_accion: float = 10  # Zona central sin acción
@export_range(0, 500, 1) var zona_accion: float = 35  # Distancia máxima de acción

# Asignación de acciones para el movimiento y las interacciones del jugador
@export var accion_mover_izquierda := "mover_izquierda"
@export var accion_mover_derecha := "mover_derecha"
@export var accion_saltar := "saltar"
@export var accion_pausa := "pausa"
@export var accion_atacar := "atacar"

# Variables de control del joystick
var esta_presionado := false
var direccion := Vector2.ZERO
var indice_toque : int = -1  # Identificador del toque activo

# Referencias a elementos visuales del joystick
@onready var fondo := $Control/Fondo
@onready var icono := $Control/Fondo/Icono

# Posiciones iniciales del joystick
@onready var posicion_fondo : Vector2 = fondo.position
@onready var posicion_icono : Vector2 = icono.position
@onready var color_original : Color = icono.modulate  # Color original del icono

func _ready() -> void:
	# Si el sistema es Windows, oculta los controles táctiles y asigna los de PC
	if OS.get_name().to_lower() == "windows":
		configurar_controles_pc()
		visible = false  # Oculta los controles en PC

	resetear_joystick()  # Restablece el estado del joystick

	# Conexión de señales para los botones de salto y ataque
	boton_saltar.connect("pressed", saltar_presionado)
	boton_saltar.connect("released", saltar_soltado)
	
	boton_atacar.connect("pressed", atacar_presionado)
	boton_atacar.connect("released", atacar_soltado)

func _input(evento: InputEvent) -> void:
	# Manejo del toque en pantalla
	if evento is InputEventScreenTouch:
		if evento.pressed:
			# Verifica si el toque está dentro del área del joystick y no hay otro toque activo
			if es_toque_dentro_del_joystick(evento.position) and indice_toque == -1:
				indice_toque = evento.index
				icono.modulate = color_presionado  # Cambia el color del icono
				actualizar_joystick(evento.position)  # Mueve el joystick según el toque
		elif evento.index == indice_toque:
			resetear_joystick()  # Restablece el joystick al soltar el toque

	# Manejo del arrastre del dedo en la pantalla (movimiento del joystick)
	elif evento is InputEventScreenDrag:
		if evento.index == indice_toque:
			actualizar_joystick(evento.position)

# Mueve el fondo del joystick a una nueva posición
func mover_fondo(nueva_posicion: Vector2) -> void:
	fondo.global_position = nueva_posicion - fondo.pivot_offset * get_global_transform_with_canvas().get_scale()

# Mueve el icono del joystick
func mover_icono(nueva_posicion: Vector2) -> void:
	icono.global_position = nueva_posicion - icono.pivot_offset * fondo.get_global_transform_with_canvas().get_scale()

# Verifica si un toque está dentro del área del joystick
func es_toque_dentro_del_joystick(posicion: Vector2) -> bool:
	var area_joystick = fondo.get_global_rect() 
	return area_joystick.has_point(posicion)

# Calcula el radio del fondo del joystick
func obtener_radio_fondo() -> Vector2:
	return fondo.size * fondo.get_global_transform_with_canvas().get_scale() / 2

# Actualiza la posición del joystick en función del toque
func actualizar_joystick(posicion_toque: Vector2) -> void:
	var radio_fondo = obtener_radio_fondo()
	var centro : Vector2 = fondo.global_position + radio_fondo  # Centro del joystick
	var vector : Vector2 = posicion_toque - centro  # Distancia desde el centro
	
	vector = vector.limit_length(zona_accion)  # Limita el radio de movimiento
	mover_icono(centro + vector)  # Actualiza la posición del icono
	
	# Si el toque supera la zona sin acción, activa el movimiento
	if vector.length_squared() > zona_sin_accion * zona_sin_accion:
		esta_presionado = true
		direccion = (vector - (vector.normalized() * zona_sin_accion)) / (zona_accion - zona_sin_accion)
	else:
		esta_presionado = false
		direccion = Vector2.ZERO

	# Gestiona la activación/desactivación de las acciones de movimiento
	if direccion.x >= 0 and Input.is_action_pressed(accion_mover_izquierda):
		Input.action_release(accion_mover_izquierda)
	if direccion.x <= 0 and Input.is_action_pressed(accion_mover_derecha):
		Input.action_release(accion_mover_derecha)
	if direccion.x < 0:
		Input.action_press(accion_mover_izquierda, -direccion.x)
	if direccion.x > 0:
		Input.action_press(accion_mover_derecha, direccion.x)

# Restablece el joystick a su estado original
func resetear_joystick():
	esta_presionado = false
	direccion = Vector2.ZERO
	indice_toque = -1
	icono.modulate = color_original
	fondo.position = posicion_fondo
	icono.position = posicion_icono

	# Libera las acciones de movimiento cuando el joystick se suelta
	for accion in [accion_mover_izquierda, accion_mover_derecha]:
		if Input.is_action_pressed(accion):
			Input.action_release(accion)

# Métodos para gestionar el botón de salto
func saltar_presionado():
	Input.action_press(accion_saltar)

func saltar_soltado():
	Input.action_release(accion_saltar)

# Métodos para gestionar el botón de ataque
func atacar_presionado():
	Input.action_press(accion_atacar) 

func atacar_soltado():
	Input.action_release(accion_atacar)

# Configuración de los controles en PC (solo si se ejecuta en Windows)
func configurar_controles_pc():
	InputMap.action_add_event("mover_izquierda", crear_evento_tecla(KEY_A))
	InputMap.action_add_event("mover_derecha", crear_evento_tecla(KEY_D))
	InputMap.action_add_event("saltar", crear_evento_tecla(KEY_SPACE))
	InputMap.action_add_event("saltar", crear_evento_tecla(KEY_W))
	InputMap.action_add_event("pausa", crear_evento_tecla(KEY_ESCAPE))
	InputMap.action_add_event("atacar", crear_evento_mouse(MOUSE_BUTTON_LEFT))

# Crea un evento de teclado para asignar controles
func crear_evento_tecla(tecla):
	var evento = InputEventKey.new()
	evento.keycode = tecla
	evento.pressed = true
	return evento 

# Crea un evento de ratón para asignar acciones
func crear_evento_mouse(boton):
	var evento = InputEventMouseButton.new()
	evento.button_index = boton  
	evento.pressed = true
	return evento

# Maneja el evento del botón de pausa
func _on_pausa_pressed() -> void:
	Input.action_press(accion_pausa)
	get_tree().create_timer(0.1)  # Pequeña pausa antes de liberar la acción
	Input.action_release(accion_pausa)
