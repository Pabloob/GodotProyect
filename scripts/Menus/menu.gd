extends Control

@export var icon_salir_hover:Texture2D
@export var icon_start_hover:Texture2D
@export var icon_salir_idle:Texture2D
@export var icon_start_idle:Texture2D
@onready var Exit=$TextureRect/Container/VBoxContainer2/Exit
@onready var Start=$TextureRect/Container/VBoxContainer/Start

func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/menuNiveles.tscn")

func _on_exit_pressed():	
	get_tree().quit()


func _on_start_mouse_entered() -> void:
	Start.icon=icon_start_hover

func _on_exit_mouse_entered() -> void:
	Exit.icon=icon_salir_hover

func _on_start_mouse_exited() -> void:
	Start.icon=icon_start_idle

func _on_exit_mouse_exited() -> void:
	Exit.icon=icon_salir_idle
