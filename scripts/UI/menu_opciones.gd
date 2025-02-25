extends Control

@onready var slider_musica = $ContenedorSliders/Volumen
@onready var slider_efectos = $ContenedorSliders/EfectosSonido
@export_file("*.tscn") var rutaMenu:String

func _ready():
	slider_musica.value = GameData.volumen_musica
	slider_efectos.value = GameData.volumen_efectos

func _on_volumen_value_changed(value: float) -> void:
	var db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(0, db_value)
	GameData.volumen_musica = value
	
func _on_efectos_sonido_value_changed(value: float) -> void:
	var db_value = linear_to_db(value / 100.0)
	AudioServer.set_bus_volume_db(1, db_value)
	GameData.volumen_efectos = value

func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file(rutaMenu)


func _on_resetear_pressed() -> void:
	GameData.resetear_partida()
	get_tree().change_scene_to_file(rutaMenu)
