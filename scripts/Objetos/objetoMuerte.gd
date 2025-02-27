extends Area2D

# Detecta cuando un cuerpo entra en el área del objeto
func _on_body_entered(body):
	# Verifica si el cuerpo pertenece al grupo "jugador"
	if body.is_in_group("jugador"):
		# Evita llamar a _morir() si el jugador ya está muerto
		if not body.esta_muerto:
			body._morir()
