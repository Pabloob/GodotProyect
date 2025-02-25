extends Control

@export_dir var LEVELS_FOLDER: String
@export_file("*.tscn") var rutaMenu: String
@export var assetBloqueado: CompressedTexture2D  # Imagen para niveles bloqueados

@onready var grid = $ContenedorBotones
@onready var boton_base = $ContenedorBotones/BotonBase

func _ready():
	var dir_access = DirAccess.open(LEVELS_FOLDER)
	if dir_access:
		dir_access.list_dir_begin()
		var file = dir_access.get_next()
		var contador = 1
		var levels_list = []  
		
		while file != "":
			if file.ends_with(".tscn"):
				var full_path = LEVELS_FOLDER + "/" + file
				levels_list.append(full_path) 
			file = dir_access.get_next()

		dir_access.list_dir_end()
		
		levels_list.sort()
		GameData.niveles = levels_list
		
		for i in range(levels_list.size()):
			var level_path = levels_list[i]
			var new_button = boton_base.duplicate()
			new_button.show()
			new_button.set_meta("nivel_path", level_path)
			if level_path not in GameData.niveles_disponibles:
				new_button.disabled = true
				new_button.icon = assetBloqueado
			else:
				new_button.text = str(i + 1)
				
			new_button.connect("pressed", _on_level_button_pressed.bind(new_button))
			grid.add_child(new_button)

func _on_level_button_pressed(button: Button):
	var level_file = button.get_meta("nivel_path", "")
	GameData.nivel_actual = level_file
	GameData.nivel_index = GameData.niveles.find(level_file) 

	var main_scene = load("res://NivelPrincipal.tscn").instantiate()
	get_tree().root.add_child(main_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_scene

func _on_salir_pressed() -> void:
	get_tree().change_scene_to_file(rutaMenu)
