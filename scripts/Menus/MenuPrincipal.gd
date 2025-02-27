extends Control

# Rutas de las escenas del menú de niveles y opciones
@export_file("*.tscn") var rutaMenuNiveles: String
@export_file("*.tscn") var rutaOpciones: String

func _ready():
	# Carga los datos guardados del juego
	GameData.cargar_partida()

	# Reproduce la música del menú
	Sonidos.reproducir_musica("musica_menu")

# Cambia a la escena del menú de niveles cuando se presiona "Jugar"
func _on_jugar_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().change_scene_to_file(rutaMenuNiveles)

# Cambia a la escena de opciones cuando se presiona "Opciones"
func _on_opciones_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().change_scene_to_file(rutaOpciones)

# Guarda la partida y cierra el juego cuando se presiona "Salir"
func _on_salir_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	GameData.guardar_partida()
	get_tree().quit()
