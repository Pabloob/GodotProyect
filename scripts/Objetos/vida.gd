extends Area2D

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		GameData.vidas += 1

		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_vidas(GameData.vidas)
		queue_free()
