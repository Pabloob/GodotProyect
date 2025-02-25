extends CharacterBody2D

const JUMP_HEIGHT = -250
const GRAVITY = 15
const MOVE_SPEED_DEFAULT = 100
const MAX_SPEED_DEFAULT = 150

@export var cooldown_ataque: float = 1.1

var MOVE_SPEED = MOVE_SPEED_DEFAULT
var MAX_SPEED = MAX_SPEED_DEFAULT
var is_dead := false
var atacando := false
var puede_atacar := true
var recibiendo_dano := false
var enemigos_en_area: Array[Node2D] = []
var llaves=1
@onready var anim = $sprite
@onready var area_deteccion = $Area2D

func _ready():
	anim.play("idle")

func _physics_process(_delta):
	if is_dead:
		return

	# Aplicar gravedad y procesar movimiento
	if not is_on_floor():
		velocity.y += GRAVITY

	_procesar_movimiento()
	move_and_slide()
	_actualizar_animacion()

func _procesar_movimiento():
	if atacando or recibiendo_dano:
		velocity.x = 0
		return

	var input_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.x = input_direction * MOVE_SPEED
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	# Salto
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_HEIGHT

	# Ataque
	if Input.is_action_just_pressed("atack") and puede_atacar:
		_atacar()

	# Voltear sprite según la dirección del movimiento
	if input_direction != 0:
		anim.flip_h = input_direction < 0

func _actualizar_animacion():
	if is_dead:
		return

	if atacando:
		anim.play("kick")
	elif recibiendo_dano:
		anim.play("hurt")
	elif not is_on_floor():
		anim.play("jump")
		await anim.animation_finished
	elif velocity.x != 0:
		anim.play("move")
	else:
		anim.play("idle")

func _atacar():
	if atacando or recibiendo_dano or not is_on_floor():
		return

	atacando = true
	puede_atacar = false
	anim.play("kick")
	await anim.animation_finished

	# Aplicar daño a enemigos en el área
	for enemigo in enemigos_en_area:
		if is_instance_valid(enemigo):
			enemigo.recibir_dano(2)

	atacando = false
	await get_tree().create_timer(cooldown_ataque).timeout
	puede_atacar = true

func perder_vida(numVidas: int):
	if is_dead or recibiendo_dano:
		return

	GameData.vidas -= numVidas

	if GameData.vidas <= 0:
		_morir()
	else:
		_recibir_golpe()

func _morir():
	is_dead = true
	anim.play("dead")
	GameData.vidas = 3
	GameData.monedasTemp = 0
	await get_tree().create_timer(1.0).timeout
	var ui = get_tree().get_first_node_in_group("ui")
	ui.mostrarMensaje(true)

func _recibir_golpe():
	recibiendo_dano = true
	anim.play("hurt")
	await anim.animation_finished
	recibiendo_dano = false
	actualizar_vidas_ui()

func actualizar_vidas_ui():
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.actualizar_vidas(GameData.vidas)

func cambiar_velocidad(nueva_velocidad: float, nueva_max_speed: float) -> void:
	MOVE_SPEED = nueva_velocidad
	MAX_SPEED = nueva_max_speed

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemigo") and body not in enemigos_en_area:
		enemigos_en_area.append(body)

func _on_area_2d_body_exited(body: Node2D):
	if body in enemigos_en_area:
		enemigos_en_area.erase(body)
