extends CharacterBody2D

const ALTURA_SALTO = -250
const GRAVEDAD = 15

@export var COOLDOWN_ATAQUE: float = 1.1

var velocidad_movimiento = 100
var velocidad_maxima_movimiento = 150
var esta_muerto := false
var atacando := false
var puede_atacar := true
var recibiendo_dano := false
var enemigos_en_area: Array[Node2D] = []

var llaves = 0
var monedas_recogidas_nivel = GameData.monedas

@onready var anim = $sprite
@onready var area_deteccion = $Area2D

func _ready():
	anim.play("normal")
	GameData.resetear_nivel()

func _physics_process(_delta):
	if esta_muerto:
		return

	if not is_on_floor():
		velocity.y += GRAVEDAD

	_procesar_movimiento()
	move_and_slide()
	_actualizar_animacion()

func _procesar_movimiento():
	if atacando or recibiendo_dano:
		_detener_movimiento()
		return

	var input_direction = Input.get_action_strength("mover_derecha") - Input.get_action_strength("mover_izquierda")
	velocity.x = clamp(input_direction * velocidad_movimiento, -velocidad_maxima_movimiento, velocidad_maxima_movimiento)

	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = ALTURA_SALTO
		SonidosPersonaje.play_saltar()

	if Input.is_action_just_pressed("atacar") and puede_atacar:
		_atacar()

	if input_direction != 0:
		anim.flip_h = input_direction < 0

func _detener_movimiento():
	velocity.x = 0

func _actualizar_animacion():
	if esta_muerto:
		return

	if atacando:
		anim.play("patada")
	elif recibiendo_dano:
		anim.play("recibirDaño")
	elif not is_on_floor():
		anim.play("saltar")
	elif velocity.x != 0:
		SonidosPersonaje.play_caminar()
		anim.play("caminar")
	else:
		anim.play("normal")

func _atacar():
	if atacando or recibiendo_dano or not is_on_floor():
		return

	atacando = true
	puede_atacar = false
	anim.play("patada")
	await anim.animation_finished

	for enemigo in enemigos_en_area:
		if is_instance_valid(enemigo):
			enemigo.recibir_dano(2)
			SonidosPersonaje.play_pegar()

	atacando = false
	await get_tree().create_timer(COOLDOWN_ATAQUE).timeout
	puede_atacar = true

func perder_vida(num_vidas: int):
	GameData.vidas -= num_vidas
	var ui = get_tree().get_first_node_in_group("ui")
	ui.actualizar_vidas(GameData.vidas)
	
	if GameData.vidas <= 0:
		_morir()
		return

	recibiendo_dano = true
	anim.play("recibirDaño")
	await anim.animation_finished
	recibiendo_dano = false

func _morir():
	esta_muerto = true
	Sonidos.reproducir_sfx("derrota")
	anim.play("muerto")
	await get_tree().create_timer(1.0).timeout
	var ui = get_tree().get_first_node_in_group("ui")
	ui.mostrarMensaje(true)

func cambiar_velocidad(nueva_velocidad: float, nueva_velocidad_maxima_movimiento: float) -> void:
	velocidad_movimiento = nueva_velocidad
	velocidad_maxima_movimiento = nueva_velocidad_maxima_movimiento

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemigo") and body not in enemigos_en_area:
		enemigos_en_area.append(body)

func _on_area_2d_body_exited(body: Node2D):
	enemigos_en_area.erase(body)
