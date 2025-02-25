extends Control

@onready var texto = $Fondo/Texto
@onready var botonReintentar = $Fondo/ContenedorBotones/Reintentar
@onready var botonSiguiente = $Fondo/ContenedorBotones/Siguiente
@export_file("*.tscn") var rutaNivelPrincipal:String
@export_file("*.tscn") var rutaMenuNiveles:String

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
	var siguiente_index = GameData.nivel_index + 1
	if siguiente_index < GameData.niveles.size():
		GameData.nivel_actual = GameData.niveles[siguiente_index]
		GameData.nivel_index = siguiente_index
		
		var main_scene = load(rutaNivelPrincipal).instantiate()
		get_tree().root.add_child(main_scene)
		get_tree().current_scene.queue_free()
		get_tree().current_scene = main_scene
	else:
		get_tree().change_scene_to_file(rutaMenuNiveles)

func _on_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file(rutaMenuNiveles)


func _on_reintentar_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
