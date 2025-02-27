extends Control

@onready var texto = $Fondo/Texto
@onready var botonReintentar = $Fondo/ContenedorBotones/Reintentar
@onready var botonSiguiente = $Fondo/ContenedorBotones/Siguiente
@export_file("*.tscn") var rutaNivelPrincipal: String
@export_file("*.tscn") var rutaMenuNiveles: String

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func mostrar_ui(muerto: bool):
	texto.text = "HAS MUERTO" if muerto else "HAS GANADO!!!"
	botonReintentar.visible = muerto
	botonSiguiente.visible = not muerto
	visible = true
	get_tree().paused = true 

func _on_siguiente_pressed():
	get_tree().paused = false
	var siguiente_index = GameData.nivel_index + 1

	if siguiente_index < GameData.niveles.size():
		GameData.nivel_actual = GameData.niveles[siguiente_index]
		GameData.nivel_index = siguiente_index
		cargar_nivel(rutaNivelPrincipal)
	else:
		cargar_nivel(rutaMenuNiveles)

func _on_salir_pressed():
	get_tree().paused = false
	cargar_nivel(rutaMenuNiveles)

func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func cargar_nivel(ruta: String):
	var main_scene = load(ruta).instantiate()
	get_tree().root.add_child(main_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_scene
