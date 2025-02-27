extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		Sonidos.reproducir_sfx("victoria")
		var ui = get_tree().get_first_node_in_group("ui")
		ui.mostrarMensaje(false)
		desbloquear_siguiente_nivel()
		GameData.monedas=body.monedas_recogidas_nivel
		GameData.guardar_partida()
		
func desbloquear_siguiente_nivel():
	var siguiente_index = GameData.nivel_index + 1
	if siguiente_index < GameData.niveles.size():
		var siguiente_nivel = GameData.niveles[siguiente_index]
		GameData.niveles_disponibles.append(siguiente_nivel)
