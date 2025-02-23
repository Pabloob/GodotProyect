extends CharacterBody2D

# Constantes
var MOVE_SPEED = 100
var MAX_SPEED = 150
const JUMP_HEIGHT = -250
const GRAVITY = 15  

@onready var anim = $sprite
@onready var area_deteccion = $Area2D

@export var cooldown_ataque: float = 1.0

var is_dead := false
var atacando := false
var puede_atacar := true
var recibiendo_dano := false # NUEVA BANDERA
var enemigos_en_area: Array[Node2D] = []

func _ready():
	anim.play("walk")

func _physics_process(delta):
	if is_dead:
		return

	_aplicar_gravedad()
	_procesar_movimiento()
	_actualizar_animacion()

	move_and_slide()

func _aplicar_gravedad():
	if not is_on_floor():
		velocity.y += GRAVITY

func _procesar_movimiento():
	var input_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if atacando or recibiendo_dano:
		velocity.x = 0
	else:
		velocity.x = input_direction * MOVE_SPEED

	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)

	if Input.is_action_just_pressed("move_up") and is_on_floor() and not atacando and not recibiendo_dano:
		velocity.y = JUMP_HEIGHT

	if Input.is_action_just_pressed("left_click") and not atacando and puede_atacar and not recibiendo_dano:
		_atacar()

	# Voltear sprite según dirección
	if input_direction != 0:
		anim.flip_h = input_direction < 0

func _actualizar_animacion():
	if atacando or recibiendo_dano or is_dead:
		return

	if is_on_floor():
		if velocity.x != 0:
			anim.play("move")
		else:
			anim.play("idle")
	else:
		anim.play("jump")

func _atacar():
	atacando = true
	puede_atacar = false

	anim.play("kick")
	await anim.animation_finished
	# Aplicar daño a enemigos
	for enemigo in enemigos_en_area:
		if is_instance_valid(enemigo):
			enemigo.recibir_dano(2)

	enemigos_en_area.clear()

	atacando = false

	# Cooldown para el siguiente ataque
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
	GameData.monedas = 0
	await get_tree().create_timer(1.0).timeout
	get_tree().reload_current_scene()

func _recibir_golpe():
	recibiendo_dano = true

	anim.play("hurt")
	await anim.animation_finished

	recibiendo_dano = false
	actualizar_vidas_ui()

func actualizar_vidas_ui():
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.actualizar_vidas(GameData.vidas)

func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemigos"):
		enemigos_en_area.append(body)

func _on_area_2d_body_exited(body: Node2D):
	if body.is_in_group("enemigos"):
		enemigos_en_area.erase(body)
