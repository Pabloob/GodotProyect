extends Control

@export_file("*.tscn") var rutaMenuNiveles:String

func _ready():
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func _physics_process(_delta):
	if Input.is_action_just_pressed("pausa"):
		if get_tree().paused:
			_on_resume_pressed()
		else:
			visible = true
			get_tree().paused = true

func _on_resume_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func _on_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file(rutaMenuNiveles)
