extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		var ui = get_tree().get_first_node_in_group("ui")
		ui.mostrarMensajeHasGanado(false)
		
