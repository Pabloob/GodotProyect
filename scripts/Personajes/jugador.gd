extends CharacterBody2D

# Constantes para el comportamiento del salto y la gravedad
const ALTURA_SALTO = -250  # Fuerza del salto
const GRAVEDAD = 15  # Fuerza de gravedad aplicada al personaje

# Variable exportada para definir el tiempo de espera entre ataques
@export var COOLDOWN_ATAQUE: float = 0.7

# Variables de movimiento y estado del personaje
var velocidad_movimiento = 100
var velocidad_maxima_movimiento = 150
var esta_muerto := false  # Indica si el personaje ha muerto
var atacando := false  # Indica si el personaje está atacando
var puede_atacar := true  # Controla si puede realizar otro ataque
var recibiendo_dano := false  # Controla si el personaje está recibiendo daño
var enemigos_en_area: Array[Node2D] = []  # Lista de enemigos en el área de ataque

# Variables relacionadas con la recolección de objetos
var llaves = 0
var monedas_recogidas_nivel = GameData.monedas  # Número de monedas recolectadas en el nivel actual

# Referencias a nodos en la escena
@onready var anim = $sprite  # Nodo de animación del personaje
@onready var area_deteccion = $Area2D  # Área de detección de enemigos

func _ready():
	anim.play("normal")  # Inicia la animación en estado normal
	GameData.resetear_nivel()  # Reinicia los valores del nivel

func _physics_process(_delta):
	if esta_muerto:
		return  # No realiza ninguna acción si el personaje está muerto

	# Aplicación de la gravedad cuando no está en el suelo
	if not is_on_floor():
		velocity.y += GRAVEDAD

	_procesar_movimiento()
	move_and_slide()  # Aplica el movimiento del personaje
	_actualizar_animacion()  # Actualiza la animación según el estado del personaje

func _procesar_movimiento():
	# Si el personaje está atacando o recibiendo daño, detiene su movimiento
	if atacando or recibiendo_dano:
		_detener_movimiento()
		return

	# Obtiene la dirección de movimiento del jugador
	var input_direction = Input.get_action_strength("mover_derecha") - Input.get_action_strength("mover_izquierda")
	velocity.x = clamp(input_direction * velocidad_movimiento, -velocidad_maxima_movimiento, velocidad_maxima_movimiento)

	# Realiza el salto si el personaje está en el suelo
	if Input.is_action_just_pressed("saltar") and is_on_floor():
		velocity.y = ALTURA_SALTO
		SonidosPersonaje.play_saltar()  # Reproduce el sonido de salto

	# Inicia el ataque si está disponible
	if Input.is_action_just_pressed("atacar") and puede_atacar:
		_atacar()

	# Voltea el sprite según la dirección de movimiento
	if input_direction != 0:
		anim.flip_h = input_direction < 0

func _detener_movimiento():
	velocity.x = 0  # Detiene completamente el movimiento del personaje

func _actualizar_animacion():
	# Si el personaje está muerto, no cambia la animación
	if esta_muerto:
		return

	# Cambia la animación según el estado actual
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
	# Solo permite el ataque si el personaje está en el suelo y no está recibiendo daño
	if atacando or recibiendo_dano or not is_on_floor():
		return

	atacando = true
	puede_atacar = false
	anim.play("patada")  # Cambia la animación al ataque
	await anim.animation_finished

	# Aplica daño a los enemigos en el área de ataque
	for enemigo in enemigos_en_area:
		if is_instance_valid(enemigo):
			enemigo.recibir_dano(2)
			SonidosPersonaje.play_pegar()  # Reproduce el sonido de ataque

	atacando = false
	await get_tree().create_timer(COOLDOWN_ATAQUE).timeout  # Espera el cooldown antes de permitir otro ataque
	puede_atacar = true

func perder_vida(num_vidas: int):
	# Reduce la cantidad de vidas del jugador
	GameData.vidas -= num_vidas
	
	# Actualiza la interfaz con la cantidad de vidas restantes
	var ui = get_tree().get_first_node_in_group("ui")
	ui.actualizar_vidas(GameData.vidas)

	# Si las vidas llegan a 0, el personaje muere
	if GameData.vidas <= 0:
		_morir()
		return

	# Si aún tiene vidas, muestra la animación de recibir daño
	recibiendo_dano = true
	anim.play("recibirDaño")
	await anim.animation_finished
	recibiendo_dano = false

func _morir():
	esta_muerto = true
	Sonidos.detener_musica()  # Detiene la música del juego
	Sonidos.reproducir_sfx("derrota")  # Reproduce el sonido de derrota
	anim.play("muerto")
	await get_tree().create_timer(1.0).timeout  # Espera 1 segundo antes de mostrar el mensaje de muerte
	var ui = get_tree().get_first_node_in_group("ui")
	ui.mostrarMensaje(true)  # Muestra la UI de derrota

func cambiar_velocidad(nueva_velocidad: float, nueva_velocidad_maxima_movimiento: float) -> void:
	# Permite modificar la velocidad del personaje en tiempo de ejecución
	velocidad_movimiento = nueva_velocidad
	velocidad_maxima_movimiento = nueva_velocidad_maxima_movimiento

# Detecta cuando un enemigo entra en el área de detección
func _on_area_2d_body_entered(body: Node2D):
	if body.is_in_group("enemigo") and body not in enemigos_en_area:
		enemigos_en_area.append(body)

# Detecta cuando un enemigo sale del área de detección
func _on_area_2d_body_exited(body: Node2D):
	enemigos_en_area.erase(body)
