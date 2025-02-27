extends Node2D

# Referencias a los fondos en la escena
@onready var fondo1 = $Fondo1
@onready var fondo2 = $Fondo2

# Activa el primer fondo y oculta el segundo
func activar_fondo_1():
	fondo1.visible = true
	fondo2.visible = false

# Activa el segundo fondo y oculta el primero
func activar_fondo_2():
	fondo1.visible = false
	fondo2.visible = true
