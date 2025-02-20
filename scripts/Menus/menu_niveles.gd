extends Control

# Ruta a la carpeta que contiene los TileMapLayers
const LEVELS_FOLDER = "res://scenes/Niveles/"

# Nombre del nodo principal del nivel
const LEVEL_ROOT_NODE = "NivelPrincipal"

# Referencia al Grid y al botón predeterminado
@onready var grid = $Grid
@onready var boton_base = $Grid/BotonBase

func _ready():
	# Obtener todos los archivos .tscn en la carpeta de niveles
	var dir_access = DirAccess.open(LEVELS_FOLDER)
	
	if dir_access:
		dir_access.list_dir_begin()
		var file = dir_access.get_next()
		var contador = 1
		
		while file != "":
			# Verificar que el archivo sea un .tscn
			if file.ends_with(".tscn"):
				# Crear un nuevo botón basado en el predeterminado
				var new_button = boton_base.duplicate()
				new_button.show()
				
				var label_nuevo = new_button.get_node("Label")
				label_nuevo.text = str(contador)
				
				# Guardar la ruta del nivel como meta-dato
				new_button.set_meta("nivel_path", LEVELS_FOLDER + file)
				
				# Conectar la señal pressed al manejador
				new_button.connect("pressed", _on_level_button_pressed.bind(new_button))
				
				grid.add_child(new_button)
				contador += 1
			
			# Obtener el siguiente archivo
			file = dir_access.get_next()
		
		# Finalizar la lista de directorios
		dir_access.list_dir_end()

func _on_level_button_pressed(button: Button):
	# Obtener la ruta del nivel desde el meta-dato del botón
	var level_file = button.get_meta("nivel_path", "")
	if level_file == "":
		print("Error: No se encontró la ruta del nivel.")
		return

	# Cargar el nivel principal
	var main_scene = ResourceLoader.load("res://NivelPrincipal.tscn")
	if main_scene == null:
		print("Error: No se pudo cargar la escena principal.")
		return
	
	var main_instance = main_scene.instantiate()

	# Cargar el TileMapLayer correspondiente
	var tilemap_layer = ResourceLoader.load(level_file)
	if tilemap_layer == null:
		print("Error: No se pudo cargar el TileMapLayer:", level_file)
		return
	
	var tilemap_instance = tilemap_layer.instantiate()

	# Usar el método setMapa para reemplazar el TileMapLayer
	main_instance.call("setMapa")
#, tilemap_instance
	# Mostrar el nivel cargado
	get_tree().change_scene_to_file("res://NivelPrincipal.tscn")
