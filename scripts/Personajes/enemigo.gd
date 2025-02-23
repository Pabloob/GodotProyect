extends CharacterBody2D

@export var velocidad: float
@export var limite_izquierdo: float
@export var limite_derecho: float
@export var vida: int

var direccion := 1
var persiguiendo := false
var atacando := false
var recibiendoDano=false
var objetivo_x := 0.0
var posicion_inicial_x := 0.0
var jugador_en_area := false
var jugador_objetivo: Node2D = null
var objetivo_ataque: Node2D = null

@onready var sprite = $sprite
@onready var area_ataque = $AreaAtaque

func _ready():
	posicion_inicial_x = position.x
	sprite.play("walk")

func _physics_process(delta):
	if vida <= 0:
		return

	if atacando:
		velocity.x = 0
	elif persiguiendo:
		_perseguir()
	else:
		_patrullar()

	move_and_slide()

	if not atacando and not recibiendoDano:
		sprite.flip_h = (direccion == 1)
		sprite.play("walk")

	_ajustar_area_ataque()

func _perseguir():
	if jugador_en_area and jugador_objetivo:
		velocity.x = direccion * velocidad

		if position.x <= posicion_inicial_x - limite_izquierdo:
			position.x = posicion_inicial_x - limite_izquierdo
			_detener_persecucion()

		elif position.x >= posicion_inicial_x + limite_derecho:
			position.x = posicion_inicial_x + limite_derecho
			_detener_persecucion()
	else:
		_detener_persecucion()

func _patrullar():
	velocity.x = direccion * velocidad
	if position.x >= posicion_inicial_x + limite_derecho:
		position.x = posicion_inicial_x + limite_derecho
		direccion = -1
	elif position.x <= posicion_inicial_x - limite_izquierdo:
		position.x = posicion_inicial_x - limite_izquierdo
		direccion = 1

func _detener_persecucion():
	velocity.x = 0
	persiguiendo = false
	jugador_objetivo = null
	jugador_en_area = false

func _ajustar_area_ataque():
	area_ataque.position.x = 10 if direccion == 1 else -10

func recibir_dano(dano: int):
	vida -= dano
	velocity.x = 0
	recibiendoDano=true
	# Interrumpir ataque si está atacando
	if atacando:
		atacando = false
		
	if vida <= 0:
		sprite.play("dead")
		await sprite.animation_finished
		queue_free()
	else:
		sprite.play("hurt")
		await sprite.animation_finished
		sprite.play("walk")
		recibiendoDano=false
		

func _on_area_ataque_body_entered(body):
	if body.name == "personaje":
		objetivo_ataque = body

	if body.name == "personaje" and not atacando and not recibiendoDano:
		atacando = true
		velocity.x = 0
		sprite.play("atack")
		await sprite.animation_finished

		if objetivo_ataque != null and is_instance_valid(objetivo_ataque) and objetivo_ataque.has_method("perder_vida"):
			objetivo_ataque.perder_vida(1)

		atacando = false


func _on_area_ataque_body_exited(body):
	if body == objetivo_ataque:
		objetivo_ataque = null

func _on_area_deteccion_izquierda_body_entered(body):
	_iniciar_persecucion(body, -1)

func _on_area_deteccion_derecha_body_entered(body):
	_iniciar_persecucion(body, 1)

func _iniciar_persecucion(body: Node2D, dir: int):
	if body.name == "personaje":
		persiguiendo = true
		jugador_objetivo = body
		jugador_en_area = true
		direccion = dir

func _on_area_deteccion_izquierda_body_exited(body):
	if body == jugador_objetivo:
		_detener_persecucion()

func _on_area_deteccion_derecha_body_exited(body):
	if body == jugador_objetivo:
		_detener_persecucion()
