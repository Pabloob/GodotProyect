extends Area2D

# Detecta cuando un cuerpo entra en el área de la llave
func _on_body_entered(body):
	# Verifica si el cuerpo pertenece al grupo "jugador"
	if body.is_in_group("jugador"):
		# Aumenta el contador de llaves recogidas por el jugador
		body.llaves += 1

		# Busca la UI en la escena y actualiza el contador de llaves si existe
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_llaves(body.llaves)

		# Elimina la llave de la escena tras ser recogida
		queue_free()
