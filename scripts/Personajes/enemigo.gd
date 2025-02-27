extends CharacterBody2D

# Variables exportadas para ajuste en el editor
@export var velocidad: float  # Velocidad de movimiento normal
@export var limite_izquierdo: float  # Límite de patrulla izquierda
@export var limite_derecho: float  # Límite de patrulla derecha
@export var vida: int  # Vida del enemigo
@export var llave_escena: PackedScene  # Escena de la llave (drop tras la muerte)

# Variables de control
var direccion := 1  # Dirección de movimiento (1 derecha, -1 izquierda)
var persiguiendo := false  # Indica si está persiguiendo al jugador
var atacando := false  # Indica si está atacando
var recibiendoDano := false  # Indica si está en animación de daño
var jugador_objetivo: Node2D = null  # Referencia al jugador detectado
var objetivo_ataque: Node2D = null  # Referencia al objetivo en rango de ataque

# Variables de vida y velocidad máximas
var vida_max
var velocidad_max

# Referencias a nodos hijos
@onready var sprite = $sprite  # Sprite animado del enemigo
@onready var area_ataque = $AreaAtaque  # Área de detección de ataque
@onready var posicion_inicial_x = position.x  # Posición inicial en X

func _ready():
	sprite.play("caminar")  # Inicia con la animación de caminar
	vida_max = vida  # Guarda la vida máxima
	velocidad_max = velocidad * 2  # Doble velocidad cuando está en estado de alerta

func _physics_process(_delta):
	# Si la vida es 0, no hace nada
	if vida <= 0:
		return

	# Prioridad de comportamiento: atacar > perseguir > patrullar
	if atacando:
		velocity.x = 0  # Detiene el movimiento si está atacando
	elif persiguiendo:
		_perseguir()
	else:
		_patrullar()

	move_and_slide()  # Aplica el movimiento

	# Ajusta la animación según el estado
	if not atacando and not recibiendoDano:
		sprite.flip_h = (direccion == 1)  # Voltea el sprite según la dirección

		if vida > vida_max / 2:
			sprite.play("caminar")
		else:
			sprite.play("correr")  # Corre si su vida está por debajo de la mitad
			velocidad = velocidad_max  # Aumenta la velocidad

func _process(_delta):
	# Si hay un objetivo en el área de ataque, intenta atacarlo
	if objetivo_ataque and is_instance_valid(objetivo_ataque):
		_iniciar_ataque()

func _perseguir():
	# Persigue al jugador si está dentro del área de detección
	if jugador_objetivo and is_instance_valid(jugador_objetivo):
		velocity.x = direccion * velocidad  # Se mueve en la dirección del jugador

		# Limites de la zona de persecución
		var limite_izq = posicion_inicial_x - limite_izquierdo
		var limite_der = posicion_inicial_x + limite_derecho

		# Si el enemigo llega a un límite, detiene la persecución
		if position.x <= limite_izq:
			position.x = limite_izq
			_detener_persecucion()
		elif position.x >= limite_der:
			position.x = limite_der
			_detener_persecucion()
	else:
		_detener_persecucion()

func _patrullar():
	# Movimiento automático entre los límites predefinidos
	velocity.x = direccion * velocidad
	var limite_izq = posicion_inicial_x - limite_izquierdo
	var limite_der = posicion_inicial_x + limite_derecho

	# Si llega a un límite, cambia de dirección
	if position.x >= limite_der:
		position.x = limite_der
		direccion = -1
	elif position.x <= limite_izq:
		position.x = limite_izq
		direccion = 1

func _detener_persecucion():
	# Detiene la persecución si el jugador sale del área de detección
	velocity.x = 0
	persiguiendo = false
	jugador_objetivo = null

func recibir_dano(dano: int):
	# Reduce la vida y desactiva el movimiento temporalmente
	vida -= dano
	velocity.x = 0
	recibiendoDano = true
	atacando = false  # Detiene un ataque si está activo

	if vida <= 0:
		# Reproduce la animación de muerte y destruye el nodo
		sprite.play("morir")
		await sprite.animation_finished
		queue_free()

		# Si tiene asignada una llave, la instancia en su posición
		if llave_escena:
			var llave = llave_escena.instantiate()
			llave.position = position
			get_parent().add_child(llave)
	else:
		# Si sigue vivo, reproduce la animación de recibir daño
		sprite.play("recibirDaño")
		await sprite.animation_finished
		recibiendoDano = false  # Vuelve al estado normal

func _on_area_ataque_body_entered(body):
	# Si el jugador entra en el área de ataque, lo guarda como objetivo
	if body.is_in_group("jugador"):
		objetivo_ataque = body

func _on_area_ataque_body_exited(body):
	# Si el jugador sale del área de ataque, lo borra como objetivo
	if body == objetivo_ataque:
		objetivo_ataque = null

func _iniciar_ataque():
	# Inicia un ataque si tiene un objetivo válido y no está en otro estado
	if objetivo_ataque and is_instance_valid(objetivo_ataque) and not atacando and not recibiendoDano:
		atacando = true
		velocity.x = 0  # Detiene el movimiento mientras ataca
		sprite.play("atacar")
		await sprite.animation_finished

		# Si el objetivo sigue siendo válido y puede recibir daño, lo ataca
		if not recibiendoDano and objetivo_ataque and is_instance_valid(objetivo_ataque) and objetivo_ataque.has_method("perder_vida"):
			objetivo_ataque.perder_vida(1)

		atacando = false  # Termina el ataque y vuelve a su estado normal

# Detección del jugador en los sensores laterales
func _on_area_deteccion_izquierda_body_entered(body):
	_iniciar_persecucion(body, -1)

func _on_area_deteccion_derecha_body_entered(body):
	_iniciar_persecucion(body, 1)

func _iniciar_persecucion(body: Node2D, dir: int):
	# Si detecta al jugador en un lado, inicia la persecución en esa dirección
	if body.is_in_group("jugador"):
		persiguiendo = true
		jugador_objetivo = body
		direccion = dir

func _on_area_deteccion_izquierda_body_exited(body):
	# Si el jugador sale del área izquierda, detiene la persecución
	if body == jugador_objetivo:
		_detener_persecucion()

func _on_area_deteccion_derecha_body_exited(body):
	# Si el jugador sale del área derecha, detiene la persecución
	if body == jugador_objetivo:
		_detener_persecucion()
