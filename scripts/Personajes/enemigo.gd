extends CharacterBody2D

@export var velocidad: float = 50.0
@export var limite_izquierdo: float = 0.0
@export var limite_derecho: float = 500.0

var direccion: int = 1
@onready var sprite = $sprite
@onready var areaColision = $Area2D

var vida = 10
var puedeCaminar = true

func _ready():
	sprite.play("walk")  # Inicia con la animación de caminar

func _physics_process(delta):
	if vida > 0 and puedeCaminar:
		velocity.x = direccion * velocidad
		move_and_slide()

		if position.x >= limite_derecho:
			direccion = -1
		elif position.x <= limite_izquierdo:
			direccion = 1

		sprite.flip_h = (direccion == 1)  # Voltear el sprite dependiendo de la dirección
		sprite.play("walk")  # Animación de caminar

# Función para recibir daño
func recibir_dano(dano):
	vida -= dano
	puedeCaminar = false  # Detener movimiento durante daño
	print(vida)
	if vida <= 0:
		vida = 0
		sprite.play("dead")  # Reproduce la animación de muerte
		await sprite.animation_finished
		queue_free()  # Elimina al personaje
	else:
		sprite.play("hurt")  # Reproduce la animación de daño
		await sprite.animation_finished
		if vida > 0:
			sprite.play("walk")  # Vuelve a caminar después de recibir daño

	puedeCaminar = true  # Permitir caminar nuevamente después de daño

# Al entrar en el área de colisión
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		puedeCaminar = false
		sprite.play("atack")
		

		await sprite.animation_finished
		puedeCaminar = true

# Al salir del área de colisión
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "personaje":
		puedeCaminar = true


func _on_area_deteccion_body_entered(body: Node2D) -> void:
	if body.name == "personaje":
		if position.x - body.position.x > 0:
			direccion= -1
		else:
			direccion = 1
