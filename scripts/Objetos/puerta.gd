extends StaticBody2D

# Número de llaves necesarias para abrir la puerta
@export var numLlavesNecesarias: int = 0

# Referencias a nodos dentro de la escena
@onready var colisionador = $CollisionShape2D
@onready var label = $Label

func _ready():
	# Espera un frame antes de buscar la UI (evita errores si la UI aún no se ha cargado)
	await get_tree().process_frame
	
	# Obtiene la UI y actualiza el número de llaves necesarias
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.numLlavesNecesarias = numLlavesNecesarias
		ui.actualizar_llaves(0)

# Se activa cuando el jugador entra en el área de detección de la puerta
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		# Si el jugador tiene suficientes llaves, abre la puerta
		if body.llaves >= numLlavesNecesarias:
			label.text = "¡Puerta abierta!"
			await get_tree().create_timer(1).timeout
			queue_free()  # Elimina la puerta de la escena
		else:
			# Determina si usar "llave" o "llaves" según la cantidad
			var texto_llaves = "llave" if numLlavesNecesarias == 1 else "llaves"
			label.text = "Necesitas %d %s (Tienes %d)" % [numLlavesNecesarias, texto_llaves, body.llaves]

			# Hace que el mensaje desaparezca después de 2 segundos
			await get_tree().create_timer(2).timeout
			label.text = ""  # Borra el mensaje
