extends Control

@onready var slider_musica = $ContenedorSliders/Volumen
@onready var slider_efectos = $ContenedorSliders/EfectosSonido
@export_file("*.tscn") var rutaMenu:String

func _ready():
	slider_musica.value = GameData.volumen_musica
	slider_efectos.value = GameData.volumen_efectos

func _on_volumen_value_changed(value: float) -> void:
	Sonidos.reproducir_sfx("boton_menu")
	GameData.volumen_musica = value
	GameData.guardar_partida()
	Sonidos.actualizarVolumenMusica()
	
func _on_efectos_sonido_value_changed(value: float) -> void:
	Sonidos.reproducir_sfx("boton_menu")
	GameData.volumen_efectos = value
	GameData.guardar_partida()
	Sonidos.actualizarVolumenSFX()
	SonidosPersonaje.actualizarVolumen()
	
func _on_exit_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().change_scene_to_file(rutaMenu)


func _on_resetear_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	GameData.resetear_juego()
	get_tree().change_scene_to_file(rutaMenu)
