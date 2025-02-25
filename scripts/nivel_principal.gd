extends Node2D

@onready var mapa = $Mapa

func _ready():
	if GameData.nivel_actual != "":
		copiar_tilemap_y_nodos(GameData.nivel_actual)
	await get_tree().create_timer(0.5).timeout
	configurar_controles()

func copiar_tilemap_y_nodos(mapa_ruta: String):
	var mapa_escena = load(mapa_ruta).instantiate()
	var tilemap_fuente = mapa_escena
	tilemap_fuente.position = mapa.position
	mapa.clear()
	add_child(tilemap_fuente)

func configurar_controles():
	if OS.get_name().to_lower() == "windows":
		configurar_controles_pc()

func configurar_controles_pc():
	InputMap.action_add_event("move_left", crear_input_tecla(KEY_A))
	InputMap.action_add_event("move_right", crear_input_tecla(KEY_D))
	InputMap.action_add_event("move_up", crear_input_tecla(KEY_SPACE))
	InputMap.action_add_event("move_up", crear_input_tecla(KEY_W))
	InputMap.action_add_event("pause", crear_input_tecla(KEY_ESCAPE))
	InputMap.action_add_event("atack", crear_input_mouse(MOUSE_BUTTON_LEFT))

func crear_input_tecla(tecla):
	var event = InputEventKey.new()
	event.keycode = tecla
	return event 

func crear_input_mouse(boton):
	var event = InputEventMouseButton.new()
	event.button_index = boton  
	return event 
