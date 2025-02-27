extends Area2D

func _ready():
	# Reproduce la animación de la moneda al iniciar
	$Sprite2D.play("coin")

# Detecta cuando un cuerpo entra en el área de la moneda
func _on_body_entered(body):
	# Verifica si el cuerpo pertenece al grupo "jugador"
	if body.is_in_group("jugador"):
		# Aumenta el contador de monedas recogidas por el jugador
		body.monedas_recogidas_nivel += 1

		# Busca la UI en la escena y actualiza el contador de monedas si existe
		var ui = get_tree().get_first_node_in_group("ui")
		if ui:
			ui.actualizar_monedas(body.monedas_recogidas_nivel)

		# Elimina la moneda de la escena tras ser recogida
		queue_free()
