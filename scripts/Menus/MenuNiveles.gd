extends Control

# Carpeta donde están almacenados los niveles
@export_dir var LEVELS_FOLDER: String

# Ruta al menú principal
@export_file("*.tscn") var rutaMenu: String

# Imagen para los niveles bloqueados
@export var assetBloqueado: CompressedTexture2D

# Referencias a nodos en la escena
@onready var grid = $ContenedorBotones  # Contenedor donde se generarán los botones de niveles
@onready var boton_base = $ContenedorBotones/BotonBase  # Botón base para los niveles

func _ready():
	# Reproduce la música del menú
	Sonidos.reproducir_musica("musica_menu")

	# Abre el directorio de niveles y obtiene la lista de archivos
	var dir_access = DirAccess.open(LEVELS_FOLDER)
	if dir_access:
		dir_access.list_dir_begin()
		var file = dir_access.get_next()
		var levels_list = []  # Lista de rutas de niveles
		
		while file != "":
			var full_path = LEVELS_FOLDER + "/" + file

			# Si es un nivel (.tscn), lo añade a la lista
			if file.ends_with(".tscn"):
				levels_list.append(full_path)

			# Si es un archivo de remapeo (.remap), obtiene la ruta real
			if file.ends_with(".remap"):
				var ruta_real = obtener_ruta_real(full_path)
				levels_list.append(ruta_real)
				
			file = dir_access.get_next()
		dir_access.list_dir_end()
		
		# Ordena los niveles por nombre
		levels_list.sort()
		GameData.niveles = levels_list
		
		# Genera los botones de niveles dinámicamente
		for i in range(levels_list.size()):
			var level_path = levels_list[i]

			# Desbloquea el primer nivel si no hay niveles disponibles aún
			if i == 0 and level_path not in GameData.niveles_disponibles:
				GameData.niveles_disponibles.append(level_path)
				
			# Crea un botón duplicando el botón base
			var new_button = boton_base.duplicate()
			new_button.show()
			new_button.set_meta("nivel_path", level_path)

			# Si el nivel está bloqueado, desactiva el botón y cambia el icono
			if level_path not in GameData.niveles_disponibles:
				new_button.disabled = true
				new_button.icon = assetBloqueado
			else:
				new_button.text = str(i + 1)  # Muestra el número del nivel

			# Conecta el botón con la función que maneja la selección del nivel
			new_button.connect("pressed", _on_level_button_pressed.bind(new_button))
			grid.add_child(new_button)

# Maneja el evento cuando se presiona un botón de nivel
func _on_level_button_pressed(button: Button):
	Sonidos.reproducir_sfx("boton_nivel")

	# Obtiene la ruta del nivel seleccionado
	var level_file = button.get_meta("nivel_path", "")
	GameData.nivel_actual = level_file
	GameData.nivel_index = GameData.niveles.find(level_file)  # Guarda el índice del nivel

	# Detiene la música antes de cargar el nivel
	Sonidos.detener_musica()

	# Carga la escena del nivel principal
	var main_scene = load("res://NivelPrincipal.tscn").instantiate()
	get_tree().root.add_child(main_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_scene

# Vuelve al menú principal cuando se presiona el botón de salir
func _on_salir_pressed() -> void:
	Sonidos.reproducir_sfx("boton_menu")
	get_tree().change_scene_to_file(rutaMenu)

# Obtiene la ruta real de un archivo .remap
func obtener_ruta_real(remap_path: String) -> String:
	# Abre el archivo y obtiene su contenido
	var file = FileAccess.open(remap_path, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	# Busca la línea donde se define la ruta real del nivel
	var lines = content.split("\n")
	for line in lines:
		line = line.strip_edges()
		if line.begins_with("path="):
			var ruta_real = line.replace("path=", "").strip_edges().replace("\"", "")
			if ResourceLoader.exists(ruta_real):
				return ruta_real

	# Si no encuentra una ruta válida, devuelve un mensaje de error
	return "No hay ruta válida"
