extends Node2D

@export var tipoBicho: int = 1  # Define el tipo de animación que usará el bicho
@onready var anim = $Animacion  # Referencia al AnimationPlayer

func _ready() -> void:
	anim.play(str(tipoBicho))  # Inicia la animación según el tipo asignado

func _on_animacion_animation_finished() -> void:
	# Invierte la dirección del bicho al terminar la animación
	anim.flip_h = not anim.flip_h  

	anim.play(str(tipoBicho))  # Reproduce nuevamente la animación
