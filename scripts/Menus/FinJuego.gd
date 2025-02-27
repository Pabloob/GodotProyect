extends Control

# Referencias a los nodos dentro de la UI
@onready var texto = $Fondo/Texto  # Texto que muestra si el jugador ganó o perdió
@onready var botonReintentar = $Fondo/ContenedorBotones/Reintentar  # Botón de reintentar nivel
@onready var botonSiguiente = $Fondo/ContenedorBotones/Siguiente  # Botón para pasar al siguiente nivel

# Rutas de los archivos de escenas para cambiar de nivel o volver al menú
@export_file("*.tscn") var rutaNivelPrincipal: String
@export_file("*.tscn") var rutaMenuNiveles: String

func _ready():
	# Oculta la UI al inicio y asegura que siempre procese eventos
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

# Muestra la interfaz de resultado (victoria o derrota)
func mostrar_ui(muerto: bool):
	texto.text = "HAS MUERTO" if muerto else "HAS GANADO!!!"  # Cambia el mensaje
	botonReintentar.visible = muerto  # Solo muestra "Reintentar" si el jugador murió
	botonSiguiente.visible = not muerto  # Solo muestra "Siguiente" si ganó
	visible = true  # Hace visible la UI
	get_tree().paused = true  # Pausa el juego

# Botón "Siguiente" → Avanza al siguiente nivel o regresa al menú si no hay más niveles
func _on_siguiente_pressed():
	get_tree().paused = false  # Reactiva el juego
	var siguiente_index = GameData.nivel_index + 1  # Calcula el índice del siguiente nivel

	# Si hay un siguiente nivel, lo carga; si no, regresa al menú
	if siguiente_index < GameData.niveles.size():
		GameData.nivel_actual = GameData.niveles[siguiente_index]
		GameData.nivel_index = siguiente_index
		cargar_nivel(rutaNivelPrincipal)
	else:
		cargar_nivel(rutaMenuNiveles)

# Botón "Salir" → Regresa al menú de niveles
func _on_salir_pressed():
	get_tree().paused = false
	cargar_nivel(rutaMenuNiveles)

# Botón "Reintentar" → Reinicia el nivel actual
func _on_reintentar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()  # Recarga la escena actual

# Función para cargar una nueva escena
func cargar_nivel(ruta: String):
	var main_scene = load(ruta).instantiate()  # Carga la nueva escena
	get_tree().root.add_child(main_scene)  # La agrega al árbol de nodos
	get_tree().current_scene.queue_free()  # Libera la escena actual
	get_tree().current_scene = main_scene  # Establece la nueva escena como actual
