extends Area2D

# Se ejecuta cuando un cuerpo entra en el área del objeto
func _on_body_entered(body):
	# Verifica si el cuerpo pertenece al grupo "jugador"
	if body.is_in_group("jugador"):
		# Aumenta la cantidad de vidas en GameData
		GameData.vidas += 1

		# Busca la UI en la escena y actualiza el contador de vidas si existe
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_vidas(GameData.vidas)

		# Elimina el objeto tras ser recogido
		queue_free()
