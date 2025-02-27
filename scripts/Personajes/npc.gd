extends CharacterBody2D

# Detecta cuando el jugador entra en el área de victoria
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		# Detiene la música actual y reproduce el sonido de victoria
		Sonidos.detener_musica()
		Sonidos.reproducir_sfx("victoria")
		
		# Muestra el mensaje de victoria en la UI
		var ui = get_tree().get_first_node_in_group("ui")
		ui.mostrarMensaje(false)

		# Desbloquea el siguiente nivel si existe
		desbloquear_siguiente_nivel()

		# Guarda la cantidad de monedas recolectadas en GameData
		GameData.monedas = body.monedas_recogidas_nivel
		
		# Guarda la partida con el nuevo estado
		GameData.guardar_partida()

# Desbloquea el siguiente nivel si aún no está disponible
func desbloquear_siguiente_nivel():
	var siguiente_index = GameData.nivel_index + 1
	
	# Verifica que el siguiente nivel exista en la lista de niveles
	if siguiente_index < GameData.niveles.size():
		var siguiente_nivel = GameData.niveles[siguiente_index]
		
		# Evita agregar el nivel si ya está desbloqueado
		if siguiente_nivel not in GameData.niveles_disponibles:
			GameData.niveles_disponibles.append(siguiente_nivel)
