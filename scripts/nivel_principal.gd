extends Node2D

func setMapa():
	var tilemap_contenedor = $TileMapContenedor  # Referencia al TileMap que añadiste en el NivelPrincipal
	# Cargar la escena con el TileMapLayer
	var mapa_layer_scene = load("res://scenes/Niveles/mapa.tscn")
	var mapa_layer_instancia = mapa_layer_scene.instantiate()

	# Comprobar que es TileMapLayer
	if not mapa_layer_instancia is TileMapLayer:
		print("Error: El nodo raíz de mapa.tscn no es un TileMapLayer.")
		return

	# Opcional: Si ya había un TileMapLayer, lo quitas (para reemplazar)
	for child in tilemap_contenedor.get_children():
		if child is TileMapLayer:
			tilemap_contenedor.remove_child(child)
			child.queue_free()

	# Añadir el TileMapLayer al TileMap contenedor
	tilemap_contenedor.add_child(mapa_layer_instancia)
	mapa_layer_instancia.name = "Mapa"

	# Posición dentro del TileMapContenedor
	mapa_layer_instancia.position = Vector2(-77, 108)

	# Asegurarte de que el TileMapLayer tenga TileSet asignado (ya lo tiene en tu imagen)
	print("TileMapLayer añadido correctamente.")
