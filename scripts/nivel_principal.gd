extends Node2D

func _ready():
	if GameData.nivel_actual != "":
		copiar_tilemap_y_nodos(GameData.nivel_actual)

func copiar_tilemap_y_nodos(mapa_ruta: String):
	var mapa_escena = load(mapa_ruta).instantiate()
	var tilemap_fuente = mapa_escena
	var tilemap_destino = $Mapa
	tilemap_fuente.position = tilemap_destino.position
	tilemap_destino.clear()
	add_child(tilemap_fuente)
	
