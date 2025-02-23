extends TileMapLayer

var enZonaFinal = false

func _on_zona_normal_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if enZonaFinal:
			get_tree().get_first_node_in_group("ui").fade_out()
			get_tree().get_first_node_in_group("fondo").activar_fondo_1()
			enZonaFinal=false
		else:
			get_tree().get_first_node_in_group("ui").fade_in()

func _on_zona_final_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		if enZonaFinal:
			get_tree().get_first_node_in_group("ui").fade_in()
		else:
			get_tree().get_first_node_in_group("ui").fade_out()
			get_tree().get_first_node_in_group("fondo").activar_fondo_2()
			enZonaFinal=true
