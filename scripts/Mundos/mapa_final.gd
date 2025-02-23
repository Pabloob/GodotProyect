extends TileMapLayer

func _on_area_salida_body_entered(body: Node2D) -> void:
	if body.is_in_group("personajes"):
		body.MOVE_SPEED=150
		get_tree().get_first_node_in_group("Fondo").activar_fondo_2()
		get_tree().get_first_node_in_group("UI").fade_out()

func _on_area_entrada_body_entered(body: Node2D) -> void:
	if body.is_in_group("personajes"):
		body.MOVE_SPEED=700
		get_tree().get_first_node_in_group("Fondo").activar_fondo_1()
		get_tree().get_first_node_in_group("UI").fade_in()
