extends CharacterBody2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		var ui = get_tree().get_first_node_in_group("ui")
		ui.mostrarMensaje(false)
		GameData.monedas+=GameData.monedasTemp
		desbloquear_siguiente_nivel()
		GameData.guardar_partida()

func desbloquear_siguiente_nivel():
	var nivel_actual = GameData.nivel_actual
	var nivel_numero = int(nivel_actual.get_file().get_basename())
	var siguiente_nivel = nivel_actual.get_base_dir() + "/" + str(nivel_numero + 1) + ".tscn"

	if siguiente_nivel in GameData.niveles and siguiente_nivel not in GameData.niveles_disponibles:
		GameData.niveles_disponibles.append(siguiente_nivel)
