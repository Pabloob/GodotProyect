extends Control

const LEVELS_FOLDER = "res://scenes/Niveles/"

const LEVEL_ROOT_NODE = "NivelPrincipal"

@onready var grid = $Grid
@onready var boton_base = $Grid/BotonBase

func _ready():
	var dir_access = DirAccess.open(LEVELS_FOLDER)
	if dir_access:
		dir_access.list_dir_begin()
		var file = dir_access.get_next()
		var contador = 1
		while file != "":
			if file.ends_with(".tscn"):
				var new_button = boton_base.duplicate()
				new_button.show()
				var label_nuevo = new_button.get_node("Label")
				label_nuevo.text = str(contador)
				new_button.set_meta("nivel_path", LEVELS_FOLDER + file)
				new_button.connect("pressed", _on_level_button_pressed.bind(new_button))
				grid.add_child(new_button)
				contador += 1
			file = dir_access.get_next()
		dir_access.list_dir_end()
		
func _on_level_button_pressed(button: Button):
	var level_file = button.get_meta("nivel_path", "")
	GameData.nivel_actual = level_file

	var main_scene = load("res://NivelPrincipal.tscn").instantiate()

	get_tree().root.add_child(main_scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = main_scene
