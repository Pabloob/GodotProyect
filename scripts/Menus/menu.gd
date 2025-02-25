extends Control

@export_file("*.tscn") var rutaMenuNiveles: String
@export_file("*.tscn") var rutaOpciones: String

func _ready():
	GameData.cargar_partida()

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file(rutaMenuNiveles)

func _on_opciones_pressed() -> void:
	get_tree().change_scene_to_file(rutaOpciones)
	
func _on_salir_pressed() -> void:
	GameData.guardar_partida()
	get_tree().quit()
