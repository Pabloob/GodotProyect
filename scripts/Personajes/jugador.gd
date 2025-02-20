extends CharacterBody2D

# Constantes
const move_speed = 100
const max_speed = 150
const jump_height = -250
const gravity = 15  
const up = Vector2(0, -1)

@onready var anim = $sprite
@onready var area_deteccion = $Area2D

var is_dead = false
var atacando = false
var enemigos_en_area = []

func perder_vida():
	if not is_dead:
		anim.play("dead")
		is_dead = true
		GameData.vidas -= 1
		actualizar_vidas_ui()
		if GameData.vidas <= 0:
			GameData.vidas = 3 
			GameData.monedas = 0
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
		
func actualizar_vidas_ui():
	var ui = get_tree().get_first_node_in_group("UI")
	if ui:
		ui.actualizar_vidas(GameData.vidas)


func _ready():
	anim.play("walk")
	area_deteccion.body_entered.connect(_on_area_2d_body_entered)

func _physics_process(delta):
	if is_dead:
		return

	if not is_on_floor():
		velocity.y += gravity

	var input_direction = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

	if not atacando:
		velocity.x = input_direction * move_speed
	else:
		velocity.x = 0

	velocity.x = clamp(velocity.x, -max_speed, max_speed)

	if Input.is_action_just_pressed("move_up") and is_on_floor() and not atacando:
		velocity.y = jump_height

	if input_direction != 0:
		anim.flip_h = input_direction < 0

	# Acción de ataque con clic
	if Input.is_action_just_pressed("left_click") and not atacando:
		atacar()

	# Animaciones normales solo si NO está atacando
	if not atacando:
		if is_on_floor():
			if velocity.x != 0:
				anim.play("move")
			else:
				anim.play("idle")
		else:
			anim.play("jump")

	move_and_slide()

# Función de ataque
func atacar():
	atacando = true
	anim.play("kick") 

	await anim.animation_finished

	for enemigo in enemigos_en_area:
		enemigo.recibir_dano(2)
	enemigos_en_area.clear()
	atacando = false 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "enemigo":
		enemigos_en_area.append(body)
