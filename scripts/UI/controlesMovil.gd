extends Control

@onready var boton_saltar = $Botones/Saltar
@onready var boton_atacar = $Botones/Atacar

@export var color_presionado := Color.GRAY
@export_range(0, 200, 1) var zona_sin_accion: float = 10
@export_range(0, 500, 1) var zona_accion: float = 35

@export var accion_mover_izquierda := "mover_izquierda"
@export var accion_mover_derecha := "mover_derecha"
@export var accion_saltar := "saltar"
@export var accion_pausa := "pausa"
@export var accion_atacar := "atacar"

var esta_presionado := false
var direccion := Vector2.ZERO
var indice_toque : int = -1

@onready var fondo := $Control/Fondo
@onready var icono := $Control/Fondo/Icono

@onready var posicion_fondo : Vector2 = fondo.position
@onready var posicion_icono : Vector2 = icono.position
@onready var color_original : Color = icono.modulate

func _ready() -> void:
	if OS.get_name().to_lower() == "windows":
		configurar_controles_pc()
		visible=false
	resetear_joystick()

	boton_saltar.connect("pressed", saltar_presionado)
	boton_saltar.connect("released", saltar_soltado)
	
	boton_atacar.connect("pressed", atacar_presionado)
	boton_atacar.connect("released", atacar_soltado)

func _input(evento: InputEvent) -> void:
	if evento is InputEventScreenTouch:
		if evento.pressed:
			if es_toque_dentro_del_joystick(evento.position) and indice_toque == -1:
				indice_toque = evento.index
				icono.modulate = color_presionado
				actualizar_joystick(evento.position)
		elif evento.index == indice_toque:
			resetear_joystick()
	elif evento is InputEventScreenDrag:
		if evento.index == indice_toque:
			actualizar_joystick(evento.position)

func mover_fondo(nueva_posicion: Vector2) -> void:
	fondo.global_position = nueva_posicion - fondo.pivot_offset * get_global_transform_with_canvas().get_scale()

func mover_icono(nueva_posicion: Vector2) -> void:
	icono.global_position = nueva_posicion - icono.pivot_offset * fondo.get_global_transform_with_canvas().get_scale()

func es_toque_dentro_del_joystick(posicion: Vector2) -> bool:
	var area_joystick = fondo.get_global_rect() 
	return area_joystick.has_point(posicion)

func obtener_radio_fondo() -> Vector2:
	return fondo.size * fondo.get_global_transform_with_canvas().get_scale() / 2

func actualizar_joystick(posicion_toque: Vector2) -> void:
	var radio_fondo = obtener_radio_fondo()
	var centro : Vector2 = fondo.global_position + radio_fondo
	var vector : Vector2 = posicion_toque - centro
	vector = vector.limit_length(zona_accion)
	mover_icono(centro + vector)
	
	if vector.length_squared() > zona_sin_accion * zona_sin_accion:
		esta_presionado = true
		direccion = (vector - (vector.normalized() * zona_sin_accion)) / (zona_accion - zona_sin_accion)
	else:
		esta_presionado = false
		direccion = Vector2.ZERO

	if direccion.x >= 0 and Input.is_action_pressed(accion_mover_izquierda):
		Input.action_release(accion_mover_izquierda)
	if direccion.x <= 0 and Input.is_action_pressed(accion_mover_derecha):
		Input.action_release(accion_mover_derecha)
	if direccion.x < 0:
		Input.action_press(accion_mover_izquierda, -direccion.x)
	if direccion.x > 0:
		Input.action_press(accion_mover_derecha, direccion.x)

func resetear_joystick():
	esta_presionado = false
	direccion = Vector2.ZERO
	indice_toque = -1
	icono.modulate = color_original
	fondo.position = posicion_fondo
	icono.position = posicion_icono

	for accion in [accion_mover_izquierda, accion_mover_derecha]:
		if Input.is_action_pressed(accion):
			Input.action_release(accion)

func saltar_presionado():
	Input.action_press(accion_saltar)

func saltar_soltado():
	Input.action_release(accion_saltar)

func atacar_presionado():
	Input.action_press(accion_atacar) 

func atacar_soltado():
	Input.action_release(accion_atacar)

func configurar_controles_pc():
	InputMap.action_add_event("mover_izquierda", crear_evento_tecla(KEY_A))
	InputMap.action_add_event("mover_derecha", crear_evento_tecla(KEY_D))
	InputMap.action_add_event("saltar", crear_evento_tecla(KEY_SPACE))
	InputMap.action_add_event("saltar", crear_evento_tecla(KEY_W))
	InputMap.action_add_event("pausa", crear_evento_tecla(KEY_ESCAPE))
	InputMap.action_add_event("atacar", crear_evento_mouse(MOUSE_BUTTON_LEFT))

func crear_evento_tecla(tecla):
	var evento = InputEventKey.new()
	evento.keycode = tecla
	evento.pressed = true
	return evento 

func crear_evento_mouse(boton):
	var evento = InputEventMouseButton.new()
	evento.button_index = boton  
	evento.pressed = true
	return evento

func _on_pausa_pressed() -> void:
	Input.action_press(accion_pausa)
	get_tree().create_timer(0.1)
	Input.action_release(accion_pausa)
