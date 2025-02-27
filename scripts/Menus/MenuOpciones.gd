extends Control

# Referencias a los sliders de volumen
@onready var slider_musica = $ContenedorSliders/Volumen
@onready var slider_efectos = $ContenedorSliders/EfectosSonido

# Ruta del menú principal
@export_file("*.tscn") var rutaMenu: String

func _ready():
	# Carga los valores de volumen desde GameData y los asigna a los sliders
	slider_musica.value = GameData.volumen_musica
	slider_efectos.value = GameData.volumen_efectos
	
	# Aplica los valores de volumen a la música y los efectos de sonido al inicio
	Sonidos.actualizarVolumenMusica()
	Sonidos.actualizarVolumenSFX()
	SonidosPersonaje.actualizarVolumen()

# Evento al cambiar el volumen de la música
func _on_volumen_value_changed(value: float) -> void:
	Sonidos.reproducir_sfx("boton_menu")
	if GameData.volumen_musica != value:
		GameData.volumen_musica = value  # Guarda el nuevo valor de volumen en GameData
		GameData.guardar_partida()  # Guarda los datos del juego
		Sonidos.actualizarVolumenMusica()  # Aplica el nuevo volumen de música

# Evento al cambiar el volumen de los efectos de sonido
func _on_efectos_sonido_value_changed(value: float) -> void:
	Sonidos.reproducir_sfx("boton_menu")
	if GameData.volumen_efectos != value:
		GameData.volumen_efectos = value
		GameData.guardar_partida()
		Sonidos.actualizarVolumenSFX()  # Aplica el volumen a los efectos de sonido generales
		SonidosPersonaje.actualizarVolumen()  # Aplica el volumen a los sonidos del personaje

# Evento al presionar el botón de salir (vuelve al menú principal)
func _on_exit_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().change_scene_to_file(rutaMenu)  # Cambia a la escena del menú principal

# Evento al presionar el botón de reiniciar juego (resetea los datos y vuelve al menú)
func _on_resetear_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	GameData.resetear_juego()  # Reinicia los datos del juego
	get_tree().change_scene_to_file(rutaMenu)  # Cambia a la escena del menú principal
