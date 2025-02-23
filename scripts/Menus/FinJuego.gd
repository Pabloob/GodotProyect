extends Control

@onready var texto = $Texto/Label
@onready var botonReintentar = $Botones/Reintentar
@onready var botonSiguiente = $Botones/Siguiente

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func mostrar_ui(muerto:bool):
	if muerto:
		texto.text = "HAS MUERTO"
		botonReintentar.visible=true
	else:
		texto.text = "HAS GANADO!!!"
		botonSiguiente.visible=true
		
	visible = true
	get_tree().paused = true 

func _on_siguiente_pressed():
	get_tree().paused = false 
	get_tree().change_scene_to_file("res://scenes/UI/menuNiveles.tscn")

func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/UI/menuNiveles.tscn")


func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
