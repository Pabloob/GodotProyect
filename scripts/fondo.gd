extends Node2D

@onready var fondo1 = $Fondo1
@onready var fondo2 = $Fondo2

func activar_fondo_1():
	fondo1.visible = true
	fondo2.visible = false

func activar_fondo_2():
	fondo1.visible = false
	fondo2.visible = true
