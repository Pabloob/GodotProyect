extends CharacterBody2D

@export var velocidad: float
@export var limite_izquierdo: float
@export var limite_derecho: float
@export var vida: int
@export var llave_escena: PackedScene

var direccion := 1
var persiguiendo := false
var atacando := false
var recibiendoDano := false
var jugador_objetivo: Node2D = null
var objetivo_ataque: Node2D = null
var vida_max
var velocidad_max

@onready var sprite = $sprite
@onready var area_ataque = $AreaAtaque
@onready var posicion_inicial_x = position.x

func _ready():
	sprite.play("caminar")
	vida_max=vida
	velocidad_max = velocidad*2
	
func _physics_process(_delta):
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
		if vida > vida_max/2:
			sprite.play("caminar")
		else:
			sprite.play("correr")
			velocidad=velocidad_max

func _process(_delta):
	if objetivo_ataque and is_instance_valid(objetivo_ataque):
		_iniciar_ataque()

func _perseguir():
	if jugador_objetivo and is_instance_valid(jugador_objetivo):
		velocity.x = direccion * velocidad

		var limite_izq = posicion_inicial_x - limite_izquierdo
		var limite_der = posicion_inicial_x + limite_derecho

		if position.x <= limite_izq:
			position.x = limite_izq
			_detener_persecucion()
		elif position.x >= limite_der:
			position.x = limite_der
			_detener_persecucion()
	else:
		_detener_persecucion()

func _patrullar():
	velocity.x = direccion * velocidad
	var limite_izq = posicion_inicial_x - limite_izquierdo
	var limite_der = posicion_inicial_x + limite_derecho

	if position.x >= limite_der:
		position.x = limite_der
		direccion = -1
	elif position.x <= limite_izq:
		position.x = limite_izq
		direccion = 1

func _detener_persecucion():
	velocity.x = 0
	persiguiendo = false
	jugador_objetivo = null

func recibir_dano(dano: int):
	vida -= dano
	velocity.x = 0
	recibiendoDano = true

	atacando = false

	if vida <= 0:
		sprite.play("morir")
		await sprite.animation_finished
		queue_free()
		if llave_escena:
			var llave = llave_escena.instantiate()
			llave.position = position
			get_parent().add_child(llave)
	else:
		sprite.play("recibirDaño")
		await sprite.animation_finished
		recibiendoDano = false

func _on_area_ataque_body_entered(body):
	if body.is_in_group("jugador"):
		objetivo_ataque = body

func _on_area_ataque_body_exited(body):
	if body == objetivo_ataque:
		objetivo_ataque = null

func _iniciar_ataque():
	if objetivo_ataque and is_instance_valid(objetivo_ataque) and not atacando and not recibiendoDano:
		atacando = true
		velocity.x = 0
		sprite.play("atacar")
		await sprite.animation_finished

		if not recibiendoDano and objetivo_ataque and is_instance_valid(objetivo_ataque) and objetivo_ataque.has_method("perder_vida"):
			objetivo_ataque.perder_vida(1)

		atacando = false

func _on_area_deteccion_izquierda_body_entered(body):
	_iniciar_persecucion(body, -1)

func _on_area_deteccion_derecha_body_entered(body):
	_iniciar_persecucion(body, 1)

func _iniciar_persecucion(body: Node2D, dir: int):
	if body.is_in_group("jugador"):
		persiguiendo = true
		jugador_objetivo = body
		direccion = dir

func _on_area_deteccion_izquierda_body_exited(body):
	if body == jugador_objetivo:
		_detener_persecucion()

func _on_area_deteccion_derecha_body_exited(body):
	if body == jugador_objetivo:
		_detener_persecucion()
