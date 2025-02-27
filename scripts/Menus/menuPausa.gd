extends Control

# Ruta del menú de niveles
@export_file("*.tscn") var rutaMenuNiveles: String

func _ready():
	# Oculta el menú de pausa al inicio y permite que el nodo siempre procese eventos
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta):
	# Detecta si se presiona la tecla de pausa
	if Input.is_action_just_pressed("pausa"):
		if get_tree().paused:
			_on_resume_pressed()  # Si el juego ya está pausado, lo reanuda
		else:
			visible = true  # Muestra el menú de pausa
			get_tree().paused = true  # Pausa el juego

# Reanuda el juego y oculta el menú de pausa
func _on_resume_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().paused = false
	visible = false

# Reinicia la escena actual
func _on_restart_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().paused = false
	get_tree().reload_current_scene()

# Sale al menú de niveles
func _on_exit_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().paused = false
	get_tree().change_scene_to_file(rutaMenuNiveles)
