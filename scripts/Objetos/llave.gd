extends Area2D

func _on_body_entered(body):
	if body.is_in_group("jugador"):
		body.llaves+=1
		queue_free()
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_llaves(body.llaves)
		queue_free()
