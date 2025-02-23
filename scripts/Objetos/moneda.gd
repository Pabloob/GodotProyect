extends Area2D

func _on_body_entered(body):
	if body.is_in_group("personajes"):
		GameData.monedas += 1

		var ui = get_tree().get_first_node_in_group("UI")
		if ui:
			ui.actualizar_monedas(GameData.monedas)
		queue_free()
